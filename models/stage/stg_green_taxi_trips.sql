{{ config(materialized='view') }}


with tripdata as (

  select 

    *,
    row_number() over (
        partition by vendorid, lpep_pickup_datetime
    ) as rn

  from {{ source('stage', 'green_taxi_trips') }}
  where vendorid is not null 

)

select 
    'Green' as service_type,
    {{ dbt_utils.generate_surrogate_key(['vendorid', 'lpep_pickup_datetime']) }} as trip_id,
    -- identifiers
    cast(vendorid as integer) as vendor_id,
    cast(pulocationid as integer) as pickup_location_id, 
    cast(dolocationid as integer) as dropoff_location_id, 
    cast(payment_type as integer) as payment_type_id,
    cast(ratecodeid as integer) as rate_code_id,
    cast(trip_type as integer) as trip_type_id,

    -- resolve identifiers
    {{ get_vendor_description('vendorid') }} as vendor,
    {{ get_payment_type_description('payment_type') }} as payment_type,
    {{ get_rate_code_description('ratecodeid') }} as rate_code,
    {{ get_trip_type_description('trip_type') }} as trip_type,

    -- timestamps
    cast(lpep_pickup_datetime as timestamp) as pickup_datetime, 
    cast(lpep_dropoff_datetime as timestamp) as dropoff_datetime, 
    
    -- trip info
    if(lower(store_and_fwd_flag) = 'y', True, False) as store_and_fwd_flag,
    cast(passenger_count as integer) as passenger_count, 
    cast(trip_distance as numeric) as trip_distance,

    -- trip expenses
    cast(total_amount as numeric) as total_amount,
    cast(fare_amount as numeric) as fare_amount,
    cast(extra as numeric) as extra_amount,
    cast(mta_tax as numeric) as mta_tax_amount,
    cast(tip_amount as numeric) as tip_amount,
    cast(tolls_amount as numeric) as tolls_amount,
    cast(improvement_surcharge as numeric) as improvement_surcharge_amount,
    cast(congestion_surcharge as numeric) as congestion_surcharge_amount

from tripdata
where rn = 1

{% if var('is_test_run', default=true) %}

    limit 100

{% endif %}
