{#
    Description sources: 
        - https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf
        - https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf
        
    A numeric code signifying how the passenger paid for the trip.
    1= Credit card
    2= Cash
    3= No charge
    4= Dispute
    5= Unknown
    6= Voided trip
#}

{% macro get_payment_type_description(payment_type_id) %}

    case {{payment_type_id}}
        when 1 then 'Credit card'
        when 2 then 'Cash'
        when 3 then 'No charge'
        when 4 then 'Dispute'
        when 5 then 'Unknown'
        when 6 then 'Voided trip'
    end

{% endmacro %}