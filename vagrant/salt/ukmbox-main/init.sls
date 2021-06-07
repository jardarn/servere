include:
    - wordpress
    - ukmbox-main.wordpress
    - ukmbox-main.plugins
    - ukmbox-main.subdomains
    - apache.php-imagick

box-main-www-folder:
    file.directory:
        - name: /var/www/

box-main-bilder-sync-folder:
    file.directory:
        - name: /home/ukmno/private_sync
        - mode: 777

box-main-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/ukm.dev.conf
        - source: salt://apache/files/vhost.conf
        - template: jinja
        - defaults:
            hostname: ukm.dev
            document_root: wordpress/
        - require:
            - pkg: apache
            - ssl-key-ukm-dev
            - box-main-www-folder
        - watch_in:
            - service: apache

# SKAL UT SNART!
# Må bare fikse path for grafikk.ukm.no (vhost 🤦🏼‍♂️)
ukmdesign_git:
    git.latest:
        - name: https://github.com/UKMNorge/UKMDesign.git
        - target: /var/www/wordpress/wp-content/themes/UKMDesign
        - require:
            - service: apache
