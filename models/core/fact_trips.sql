{{ config(materialized='table') }}


with green_trips as (
    select 
        -- base info
        trip_id,
        service_type,
        vendor_id,
        -- trip details
        trip_type,
        pickup_location_id, 
        dropoff_location_id, 
        pickup_datetime, 
        dropoff_datetime, 
        store_and_fwd_flag,
        passenger_count, 
        trip_distance,
        -- payment info
        rate_code,
        payment_type,
        total_amount,
        fare_amount,
        extra_amount,
        mta_tax_amount,
        tip_amount,
        tolls_amount,
        improvement_surcharge_amount,
        congestion_surcharge_amount
    from {{ ref('stg_green_taxi_trips') }}
),

yellow_trips as (
    select 
        -- base info
        trip_id,
        service_type,
        vendor_id,
        -- trip details
        trip_type,
        pickup_location_id, 
        dropoff_location_id, 
        pickup_datetime, 
        dropoff_datetime, 
        store_and_fwd_flag,
        passenger_count, 
        trip_distance,
        -- payment info
        rate_code,
        payment_type,
        total_amount,
        fare_amount,
        extra_amount,
        mta_tax_amount,
        tip_amount,
        tolls_amount,
        improvement_surcharge_amount,
        congestion_surcharge_amount
    from {{ ref('stg_yellow_taxi_trips') }}
),

trips_unioned as (
    select * from green_trips
    union all
    select * from yellow_trips
),

zones as (
    select 
        location_id,
        borough,
        zone
    from {{ ref('dim_zones') }}
    where lower(borough) <> 'unknown'
)

select

    -- general details
    trips_unioned.trip_id,
    trips_unioned.service_type,
    trips_unioned.vendor_id,
    trips_unioned.trip_type,

    -- trip details
    trips_unioned.pickup_location_id, 
    pickup_zones.borough as pickup_borough,
    pickup_zones.zone as pickup_zone,
    trips_unioned.dropoff_location_id, 
    dropoff_zones.borough as dropoff_borough,
    dropoff_zones.zone as dropoff_zone,
    trips_unioned.pickup_datetime, 
    trips_unioned.dropoff_datetime, 
    trips_unioned.store_and_fwd_flag,
    trips_unioned.passenger_count, 
    trips_unioned.trip_distance,

    -- payment details
    trips_unioned.rate_code,
    trips_unioned.payment_type,
    trips_unioned.total_amount,
    trips_unioned.fare_amount,
    trips_unioned.extra_amount,
    trips_unioned.mta_tax_amount,
    trips_unioned.tip_amount,
    trips_unioned.tolls_amount,
    trips_unioned.improvement_surcharge_amount,
    trips_unioned.congestion_surcharge_amount

from trips_unioned

inner join zones as pickup_zones
        on trips_unioned.pickup_location_id = pickup_zones.location_id

inner join zones as dropoff_zones
        on trips_unioned.dropoff_location_id = dropoff_zones.location_id