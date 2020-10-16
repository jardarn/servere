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

box_tempdev_vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/ukm.dev.conf
        - source: salt://apache/vhost.conf
        - template: jinja
        - defaults:
            hostname: ukm.dev
            document_root: wordpress/
        - require:
            - pkg: apache
            - ssl-key-ukm-dev
        - watch_in:
            - service: apache

ukmdesign_git:
    git.latest:
        - name: https://github.com/UKMNorge/UKMDesign.git
        - target: /var/www/wordpress/wp-content/themes/UKMDesign
