box-lite-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/lite.ukm.dev.conf
        - source: salt://apache/vhost.conf
        - template: jinja
        - defaults:
            hostname: lite.ukm.dev
        - require:
            - pkg: apache
            - ssl-key-ukm-dev
        - watch_in:
            - service: apache
