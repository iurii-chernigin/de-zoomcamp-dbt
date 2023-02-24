{# 
    Sources: 
        - https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf
        - https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf

    A code indicating the TPEP provider that provided the record.
        1 = Creative Mobile Technologies, LLC; 
        2 = VeriFone Inc.
#}

{% macro get_vendor_description(vendor_id) %}

    case {{ vendor_id }}
        when 1 then 'Creative Mobile Technologies, LLC'
        when 2 then 'VeriFone Inc.'
    end

{% endmacro %}