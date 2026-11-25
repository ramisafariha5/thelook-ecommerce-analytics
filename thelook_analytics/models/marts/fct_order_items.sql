with items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
)

select
    i.order_item_id,
    i.order_id,
    i.user_id,
    i.product_id,
    i.item_status,
    i.ordered_at,
    p.category,
    p.department,
    p.brand,
    i.sale_price,
    p.cost,
    i.item_status not in ('Cancelled', 'Returned') as is_valid_revenue,
    case
        when i.item_status not in ('Cancelled', 'Returned') then i.sale_price
        else 0
    end as revenue
from items i
left join products p using (product_id)
