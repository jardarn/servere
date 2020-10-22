box-web-www-folder:
    file.directory:
        - name: /var/www/lite/

box-web-vhost:
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
            - box-web-www-folder
        - watch_in:
            - service: apache

# SKAL UT SNART!
# Må bare fikse path for grafikk.ukm.no (vhost 🤦🏼‍♂️)
ukmdesign_git:
    git.latest:
        - name: https://github.com/UKMNorge/UKMDesign.git
        - target: /var/www/wordpress/wp-content/themes/UKMDesign


include:
    - ukmboxes.subdomains