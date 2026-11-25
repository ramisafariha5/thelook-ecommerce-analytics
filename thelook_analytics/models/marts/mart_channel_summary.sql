-- One row per acquisition channel, for the dashboard.
-- Same analysis population as the notebook: 30-day window fully observed,
-- no order dated before sign-up.
select
    traffic_source,
    count(*)                                              as eligible_users,
    countif(converted_30d)                                as converted_users,
    safe_divide(countif(converted_30d), count(*))         as conversion_rate_30d,
    countif(order_count > 0)                              as buyers,
    sum(lifetime_revenue)                                 as total_revenue,
    safe_divide(sum(lifetime_revenue), countif(order_count > 0))
                                                          as avg_revenue_per_buyer
from {{ ref('dim_users') }}
where is_eligible_for_30d
  and not has_order_before_signup
group by traffic_source
