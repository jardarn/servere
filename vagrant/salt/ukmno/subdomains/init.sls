{% for file in salt['cp.list_master'] %}
    {{ file }}
{% endfor %}