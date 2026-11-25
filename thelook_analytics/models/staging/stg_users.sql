select
    id            as user_id,
    traffic_source,
    country,
    age,
    gender,
    created_at    as signed_up_at
from {{ source('thelook', 'users') }}
