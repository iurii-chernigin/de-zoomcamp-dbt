{{ config(materialized='view') }}



select 
    'FHV' as service_type,
    {{ dbt_utils.generate_surrogate_key(['pickup_datetime', 'dropOff_datetime', 'PUlocationID', 'DOlocationID']) }} as trip_id,
    pickup_datetime,
    dropOff_datetime as dropoff_datetime,
    PUlocationID as pickup_location_id,
    DOlocationID as dropoff_location_id,
    SR_Flag as is_shared_trip,
    dispatching_base_num as dispatching_base_number,
    Affiliated_base_number as affiliated_base_number
from {{ source('stage', 'fhv_taxi_trips_external') }} as trips
{% if var('is_test_run', default=false) %}

    limit 100

{% endif %}