ukmlib-config:
    file.managed:
        - name: /etc/php-includes/UKMconfig.inc.php
        - source: salt://ukmlib/files/UKMconfig.inc.php
        - template: jinja
        - show_diff: False
        - mode: 640
        - user: root
        - group: www-data
        - makedirs: True
