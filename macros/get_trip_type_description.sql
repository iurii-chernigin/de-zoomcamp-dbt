{#
    Description sources:
        - https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf

    A code indicating whether the trip was a street-hail or a dispatch
    that is automatically assigned based on the metered rate in use but
    can be altered by the driver.
        1= Street-hail
        2= Dispatch

#}

{% macro get_trip_type_description(trip_type_id) %}

    case {{ trip_type_id }}
        when 1 then 'Street-hail'
        when 2 then 'Dispatch'
    end

{% endmacro %}