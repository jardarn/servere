get-composer:
  cmd.run:
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer
    - cwd: /root/

composer:
  cmd.wait:
    - name: mv /root/composer.phar /usr/local/bin/composer
    - cwd: /root/
    - watch:
      - cmd: get-composer

composer1:
    cmd.run:
        - name: sudo cp `which composer` /usr/local/bin/composer1 && sudo composer1 self-update --1
        - unless: which composer1
        - require:
            - pkg: mod-php