select
    id            as product_id,
    category,
    department,
    brand,
    cost,
    retail_price
from {{ source('thelook', 'products') }}
