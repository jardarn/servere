{% set ukm = pillar.get('ukm', {}) %}

ukm-download-deps:
    file.directory:
        - name: /var/www/download

# Fordi ukm-download-deps ikke kan feile bare pga chown/cmod
ukm-download-deps-mode:
    file.directory:
        - name: /var/www/download
        - user: www-data
        - group: www-data
        - mode: 755

{% for folder in ['excel','word','zip'] %}
ukm-download-deps-{{ folder }}:
    file.directory:
        - name: /var/www/download/{{ folder }}
        - user: www-data
        - group: www-data
        - mode: 755
        - require:
            - ukm-download-deps
{% endfor %}
        
ukm-download-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/download.{{ ukm.hostname }}.conf
        - source: salt://apache/files/vhost-subdomain.conf
        - template: jinja
        - defaults:
          subdomain: download
        - require:
            - pkg: apache
            - ukm-download-deps