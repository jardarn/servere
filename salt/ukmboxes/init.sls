{% if 'lite' in grains['roles'] %}
    include:
        - ukmboxes.lite
{% else %}
    {{ grains['roles'] }}
{% endif %}