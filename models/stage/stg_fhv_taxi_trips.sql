{{ config(materialized='view') }}



select 
    'FHV' as service_type,
    {{ dbt_utils.generate_surrogate_key([
            'pickup_datetime', 'dropOff_datetime',
            'PUlocationID', 'DOlocationID', 
            'dispatching_base_num'
    ]) }} as trip_id,
    trips.pickup_datetime,
    trips.dropOff_datetime as dropoff_datetime,
    trips.PUlocationID as pickup_location_id,
    trips.DOlocationID as dropoff_location_id,
    trips.SR_Flag as is_shared_trip,
    trips.dispatching_base_num as dispatching_base_number,
    trips.Affiliated_base_number as affiliated_base_number
from {{ source('stage', 'fhv_taxi_trips_external') }} trips
{% if var('is_test_run', default=false) %}

    limit 100

{% endif %}