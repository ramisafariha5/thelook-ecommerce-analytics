-- One row per completed month. The current month is excluded because it is partial.
select
    date_trunc(date(ordered_at), month)   as order_month,
    count(distinct order_id)              as orders,
    count(distinct user_id)               as buying_users,
    sum(revenue)                          as revenue
from {{ ref('fct_order_items') }}
where is_valid_revenue
  and date_trunc(date(ordered_at), month) < date_trunc(current_date(), month)
group by order_month
