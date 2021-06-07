{% set mysql = pillar.get('mysql') %}
{% set videoconverter = pillar.get('videoconverter', {}) %}

include:
    - apache
    - ssl
    - mysql
#    - ffmpeg

videoconverter-deps:
    pkg.installed:
        - pkgs:
            - git
            - php7.2-curl
            #- libav-tools # Contains qt-faststart # libav-tools is obsolete, and replaced by ffmpeg proper

videoconverter:
    git.latest:
        - name: https://github.com/UKMNorge/videoconverter.git
        - target: /var/www/videoconverter
        - require:
            - pkg: videoconverter-deps

apache-headers:
    cmd.run:
        - name: a2enmod headers
        - unless: test -f /etc/apache2/mods-enabled/headers.load
        - require:
            - pkg: apache

videoconverter-mysql-user:
    mysql_user.present:
        - name: videoconverter
        - host: localhost
        - password: {{ videoconverter.get('db_pass', 'dev') }}
        - connection_user: root
        - connection_pass: {{ mysql.get('root_pass', 'dev') }}
        - connection_charset: utf8


videoconverter-mysql-grant:
    mysql_grants.present:
        - user: videoconverter
        - grant: select,insert,update
        - database: converter.*
        - host: localhost
        - connection_user: root
        - connection_pass: {{ mysql.get('root_pass', 'dev') }}
        - connection_charset: utf8
        - require:
            - mysql_user: videoconverter-mysql-user


videoconverter-database:
    mysql_database.present:
        - name: converter
        - host: localhost
        - connection_user: root
        - connection_pass: {{ mysql.get('root_pass', 'dev') }}
        - connection_charset: utf8
        - require:
            - service: mysql-server

    file.managed:
        - name: /etc/mysql/videoconverter.sql
        - source: http://dev.ukm.no/vagrant/videoconverter.sql
        - source_hash: sha1=03714d308ed76d1e34f427ee1445624b70de56e4

    cmd.wait:
        - name: mysql -u root -p{{ mysql.root_pass }} converter < /etc/mysql/videoconverter.sql
        - watch:
            - file: videoconverter-database

videoconverter-cron-final:
    cron.present:
        - name: wget -O  - http://localhost/cron/convert_final.cron.php
        - minute: "*/2"
        - identifier: cron_final


{% for cron_target in ['convert_first', 'store'] %}
videoconverter-cron-{{ cron_target }}:
    cron.present:
        - name: wget -O - http://localhost/cron/{{ cron_target }}.cron.php
        - identifier: {{ cron_target }}
{% endfor %}


{% for dir in [
    'store_hq',
    'store_temp_convert',
    'store_temp_converting',
    'store_temp_converting_pqt',
    'store_temp_transfer',
    'store_temp_transferring',
    'temp_reconvert_originals',
    'temp_storage',
    'temp_videoserver_originals',
    ] %}
videoconverter-dir-{{ dir }}:
    file.directory:
        - name: /var/www/videoconverter/{{ dir }}
        - mode: 775
        - user: vagrant
        - group: vagrant
{% endfor %}


{% for dir in [
    'convert',
    'converted',
    'log',
    'store',
    'uploaded',
    'x264',
    ] %}
videoconverter-temp-storage-dir-{{ dir }}:
    file.directory:
        - name: /var/www/videoconverter/temp_storage/{{ dir }}
        - mode: 775
        - user: vagrant
        - group: vagrant
{% endfor %}
