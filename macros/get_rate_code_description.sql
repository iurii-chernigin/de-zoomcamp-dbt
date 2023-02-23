{#
    Description sources: 
        - https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf
        - https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_green.pdf
        
    The final rate code in effect at the end of the trip.
        1 = Standard rate
        2 = JFK
        3 = Newark
        4 = Nassau or Westchester
        5 = Negotiated fare
        6 = Group ride
#}

{% macro get_rate_code_description(rate_code_id) -%}

    case {{ rate_code_id }}
        when 1 then 'Standard rate'
        when 2 then 'JFK'
        when 3 then 'Newark'
        when 4 then 'Nassau or Westchester'
        when 5 then 'Negotiated fare'
        when 6 then 'Group ride'
    end

{% endmacro %}