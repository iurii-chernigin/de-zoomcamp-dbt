{{ config(
        materialized='table',
        partition_by={
            'field': 'pickup_datetime',
            'data_type': 'timestamp',
            'granularity': 'day'
        }
    )
}}


with dim_zones as (

    select location_id, borough, zone
    from {{ ref('dim_zones') }}

)

select 
    trips.service_type,
    trips.trip_id,
    trips.pickup_datetime,
    trips.dropoff_datetime,
    pickup_zone.borough as pickup_borough,
    pickup_zone.zone as pickup_zone,
    dropoff_zone.borough as dropoff_borough,
    dropoff_zone.zone as dropoff_zone,
    trips.is_shared_trip,
    trips.dispatching_base_number,
    trips.affiliated_base_number
from {{ ref('stg_fhv_taxi_trips') }} as trips

inner join dim_zones pickup_zone
      on pickup_zone.location_id = trips.pickup_location_id
      
inner join dim_zones dropoff_zone
      on dropoff_zone.location_id = trips.dropoff_location_id