{{ config(materialized='view') }}


select 
    'Yellow' as service_type,
    {{ dbt_utils.generate_surrogate_key(['vendorid', 'tpep_pickup_datetime'])}} as trip_id,
    -- identifiers
    cast(vendorid as integer) as vendor_id,
    cast(pulocationid as integer) as pickup_location_id, 
    cast(dolocationid as integer) as dropoff_location_id, 

    -- timestamps
    cast(tpep_pickup_datetime as timestamp) as pickup_datetime, 
    cast(tpep_dropoff_datetime as timestamp) as dropoff_datetime, 
    
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
    cast(congestion_surcharge as numeric) as congestion_surcharge_amount,

    -- resolve identifiers
    {{ get_payment_type_description('payment_type') }} as payment_type,
    {{ get_rate_code_description('ratecodeid') }} as rate_code,
    cast(null as string) as trip_type

from {{ source("stage", "yellow_taxi_trips") }}
where vendorid is not null
{% if var('is_test_run', default=true) %}

    limit 100

{% endif %}

