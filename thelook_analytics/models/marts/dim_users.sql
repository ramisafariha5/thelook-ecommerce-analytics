with users as (
    select * from {{ ref('stg_users') }}
),

orders as (
    select
        user_id,
        min(ordered_at)           as first_order_at,
        count(distinct order_id)  as order_count,
        sum(revenue)              as lifetime_revenue
    from {{ ref('fct_order_items') }}
    where is_valid_revenue
    group by user_id
)

select
    u.user_id,
    u.traffic_source,
    u.country,
    u.age,
    u.gender,
    u.signed_up_at,
    o.first_order_at,
    coalesce(o.order_count, 0)       as order_count,
    coalesce(o.lifetime_revenue, 0)  as lifetime_revenue,
    coalesce(o.first_order_at < u.signed_up_at, false)
        as has_order_before_signup,
    u.signed_up_at < timestamp_sub(current_timestamp(), interval 30 day)
        as is_eligible_for_30d,
    coalesce(
        o.first_order_at >= u.signed_up_at
        and o.first_order_at <= timestamp_add(u.signed_up_at, interval 30 day),
        false
    ) as converted_30d
from users u
left join orders o using (user_id)
