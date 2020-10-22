{% set ssl = pillar.get('ssl', {}) %}

{% for part in ['crt','csr','key'] if ssl[ part ] is defined %}
ssl-{{ part }}-{{ ssl[ part ]['name']|replace('.','-') }}:
    file.managed:
        - name: /etc/apache2/ssl/{{ ssl[part]['name'] }}.{{ part }}
        - contents_pillar: {{'ssl:'~ part ~':data'}}
        - mode: 640
        - user: root
        - group: www-data
        - makedirs: True
{% endfor %}

ssl-apache-restart:
    cmd.run:
        - name: service apache2 restart
        - order: last