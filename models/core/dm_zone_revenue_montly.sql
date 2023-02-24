{{ config(materialized='table') }}


with trips_data as (

    select * 
    from {{ ref('fact_trips') }}

)

select 
-- Reveneue grouping 
pickup_zone as revenue_zone,
date_trunc(pickup_datetime, month) as revenue_month, 
service_type, 

-- Revenue calculation 
round(sum(fare_amount), 1) as revenue_monthly_fare,
round(sum(extra_amount), 1) as revenue_monthly_extra,
round(sum(mta_tax_amount), 1) as revenue_monthly_mta_tax,
round(sum(tip_amount), 1) as revenue_monthly_tip,
round(sum(tolls_amount), 1) as revenue_monthly_tolls,
round(sum(improvement_surcharge_amount), 1) as revenue_monthly_improvement_surcharge,
round(sum(total_amount), 1) as revenue_monthly_total,
round(sum(congestion_surcharge_amount), 1) as revenue_monthly_congestion_surcharge,

-- Additional calculations
count(trip_id) as total_monthly_trips,
round(avg(passenger_count), 1) as avg_montly_passenger_count,
round(avg(trip_distance), 1) as avg_montly_trip_distance

from trips_data
group by 1,2,3