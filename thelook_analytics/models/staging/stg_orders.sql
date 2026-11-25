select
    order_id,
    user_id,
    status        as order_status,
    num_of_item   as item_count,
    created_at    as ordered_at
from {{ source('thelook', 'orders') }}
