with cohorts as (
    select
        user_id,
        signed_up_at,
        date_trunc(date(signed_up_at), month) as cohort_month
    from {{ ref('dim_users') }}
    where not has_order_before_signup
),

activity as (
    select distinct
        c.user_id,
        c.cohort_month,
        div(timestamp_diff(f.ordered_at, c.signed_up_at, day), 30) as period_30d
    from {{ ref('fct_order_items') }} f
    join cohorts c using (user_id)
    where f.is_valid_revenue
),

cohort_size as (
    select cohort_month, count(*) as cohort_users
    from cohorts
    group by cohort_month
),

retained as (
    select
        cohort_month,
        period_30d,
        count(distinct user_id) as active_users
    from activity
    group by 1, 2
)

select
    r.cohort_month,
    r.period_30d,
    s.cohort_users,
    r.active_users,
    safe_divide(r.active_users, s.cohort_users) as retention_rate
from retained r
join cohort_size s using (cohort_month)
-- only show a window once every user in the cohort has been observed for all of it
where date_add(
        date_add(r.cohort_month, interval 1 month),
        interval (r.period_30d + 1) * 30 day
      ) <= current_date()
