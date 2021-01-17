include: 
    - videoconverter

box-videoconverter-www-folder:
    file.directory:
        - name: /var/www/videoconverter

box-videconverter-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/videoconverter.dev.conf
        - source: salt://apache/files/vhost.conf
        - template: jinja
        - defaults:
            hostname: videoconverter.ukm.dev
            document_root: videoconverter/
        - require:
            - pkg: apache
        - watch_in:
            - service: apache