composer:
    cmd.run:
        - name: curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
        - unless: which composer
        - require:
            - pkg: mod-php