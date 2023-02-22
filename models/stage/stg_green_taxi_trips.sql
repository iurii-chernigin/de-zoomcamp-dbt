{{ config(materialized="view") }}


select 
    -- identifiers
    cast(VendorID as integer) as vendor_id,
    cast(RatecodeID as integer) as rate_code_id, 
    cast(PULocationID as integer) as pickup_location_id, 
    cast(DOLocationID as integer) as dropoff_location_id, 
    cast(trip_type as integer) as trip_type_id,
    cast(payment_type as integer) as payment_type_id,

    -- timestamps
    cast(lpep_pickup_datetime as timestamp) as pickup_datetime, 
    cast(lpep_dropoff_datetime as timestamp) as dropoff_datetime, 
    
    -- trip info
    if(lower(store_and_fwd_flag) = 'y', True, False) as store_and_fwd_flag,
    cast(passenger_count as integer) as passenger_count, 
    cast(trip_distance as numeric) as trip_distance, 

    -- payment info
    cast(total_amount as numeric) as total_amount,
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra_amount,
    cast(mta_tax as numeric) as mta_tax_amount,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(improvement_surcharge as numeric) as improvement_surcharge_amount,
    cast(congestion_surcharge as numeric) as congestion_surcharge_amount

from {{ source("stage", "green_taxi_trips") }}
limit 100
