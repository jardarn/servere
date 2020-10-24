box-playback-www-folder:
    file.directory:
        - name: /var/www/playback/

box-playback-git:
    git.latest:
        - name: https://github.com/UKMNorge/UKMplayback.git
        - target: /var/www/playback/

box-playback-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/playback.ukm.dev.conf
        - source: salt://apache/files/vhost.conf
        - template: jinja
        - defaults:
            hostname: playback.ukm.dev
            document_root: playback/_playbackserver
        - require:
            - pkg: apache
            - ssl-key-ukm-dev
            - box-playback-git
        - watch_in:
            - service: apache
