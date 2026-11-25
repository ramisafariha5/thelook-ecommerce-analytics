select
    id            as order_item_id,
    order_id,
    user_id,
    product_id,
    status        as item_status,
    sale_price,
    created_at    as ordered_at,
    returned_at
from {{ source('thelook', 'order_items') }}
