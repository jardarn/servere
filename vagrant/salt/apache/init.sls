# Installs apache and php, and disables the apache default vhost
apache:
    pkg.installed:
        - name: apache2

    service.running:
        - name: apache2
        - require:
             - pkg: apache
        - watch:
            - mod-php
            - pkg: php-mysql

    # Remove default site
    file.absent:
        - name: /etc/apache2/sites-enabled/000-default.conf
    
php-mysql:
    pkg.installed:
        - name: php-mysql

mod-php:
    pkg.installed:
        - name: libapache2-mod-php
        - require:
            - pkg: apache
        - watch_in:
            - service: apache

php-a2enmod:
    cmd.run:
        - name: a2enmod php7.2
        - require:
            - pkg: mod-php

php-a2enmod-rewrite:
    cmd.run:
        - name: a2enmod rewrite
        - unless: test -f /etc/apache2/mods-enabled/rewrite.load
        - watch_in: 
            service: apache

php-mbstring:
    pkg.installed:
        - name: php7.2-mbstring
        - require:
            - pkg: mod-php

phpxml:
    pkg.installed:
        - name: php7.2-xml
        - require:
            - pkg: mod-php
phpgd:
    pkg.installed:
        - name: php7.2-gd
        - require:
            - pkg: mod-php

phpzip:
    pkg.installed:
        - name: php7.2-zip
        - require:
            - pkg: mod-php

phpini:
    file.managed:
        - name: /etc/php/7.2/apache2/php.ini
        - source: salt://apache/files/php.ini
        - template: jinja
        - require:
            - pkg: mod-php
        - defaults:
            memory_limit: 128M
        - watch_in:
            - service: apache

phpini-cli:
    file.managed:
        - name: /etc/php/7.2/cli/php.ini
        - source: salt://apache/files/php.ini
        - template: jinja
        - require:
            - pkg: mod-php
        - defaults:
            memory_limit: -1
        - watch_in:
            - service: apache

mod-ssl:
    cmd.run:
        - name: a2enmod ssl
        - unless: test -f /etc/apache2/mods-enabled/ssl.conf
        - require:
            - pkg: apache
        - watch_in:
            - service: apache

mod-headers:
    cmd.run:
        - name: a2enmod headers
        - unless: test -f /etc/apache2/mods-enabled/headers.load
        - require:
            - pkg: apache
        - watch_in:
            - service: apache

apache-restart:
    cmd.run:
        - name: service apache2 restart
        - order: last
