composer:
    cmd.run:
        - name: curl -sS https://getcomposer.org/installer | php && mv composer.phar /usr/local/bin/composer
        - unless: which composer
        - require:
            - pkg: mod-php

composer1:
    cmd.run:
        - name: sudo cp `which composer` /usr/local/bin/composer1 && sudo composer1 self-update --1
        - unless: which composer1
        - require:
            - pkg: mod-php