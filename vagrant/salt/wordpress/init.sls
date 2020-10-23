{% set wordpress_version = pillar.get('wordpress:version', '5.3.2') %}
{% set wordpress = pillar.get('wordpress') %}

wordpress-install:
    file.managed:
        - name: /usr/local/src/wordpress-{{ wordpress_version }}.tar.gz
        - source: http://wordpress.org/wordpress-{{ wordpress_version }}.tar.gz
        - skip_verify: True
        - unless:
            - ls /var/www/wordpress/wp-admin
    cmd.wait:
        - name: tar xf /usr/local/src/wordpress-{{wordpress_version }}.tar.gz -C /var/www --no-same-permissions --no-same-owner
        - cwd: /usr/local/src
        - watch:
            - file: wordpress-install

{% if wordpress.sunrise %}
wordpress-sunrise:
    file.managed:
        - name: /var/www/wordpress/wp-content/sunrise.php
        - source: salt://wordpress/files/sunrise.php
        - template: jinja
        - mode: 755
        - makedirs: True
{% endif %}