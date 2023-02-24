{#
    Test a column with the condition: <column> <= 0
#}


{% test is_zero_or_negative(model, column_name) %}

    select {{ column_name }}
    from {{ model }}
    where {{ column_name }} <= 0

{% endtest %}