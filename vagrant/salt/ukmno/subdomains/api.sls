ukmno-api-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/api.conf
        - source: salt://ukmno/files/vhost-subdomain.conf
        - template: jinja
        - defaults:
          subdomain: api
        - watch_in:
            - service: apache

ukmno-api:
    git.latest:
        - name: https://github.com/UKMNorge/UKMapi_public.git
        - target: /var/www/api
        - require:
            - pkg: ukmlib-deps