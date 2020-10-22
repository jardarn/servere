## PHP LIBRARIES
ukmlib-includes-deps:
    file.directory:
        - name: /etc/php-libraries
        - user: root
        - group: www-data
        - mode: 755
        - require:
            - ukmlib-deps
            
## PHP INCLUDES
https://github.com/UKMNorge/UKMapi.git:
    git.latest:
        - target: /etc/php-includes/UKM
        - require:
            - ukmlib-includes-deps

ukmapi-composer:
    cmd.run:
        - name: composer install
        - cwd: /etc/php-includes/UKM
        - require:
            - https://github.com/UKMNorge/UKMapi.git
            - composer

# LIB-COMPOSER 
ukmlib-includes-composerfile:
    file.managed:
        - name: /etc/php-libraries/composer.json
        - source: salt://ukmlib/files/composer-includes.json
        - mode: 640
        - user: root
        - group: www-data
        - require:
            - ukmlib-includes-deps

# INCLUDES-COMPOSER
ukmlib-includes-composer:
    cmd.run:
        - name: composer install
        - cwd: /etc/php-libraries/
        - require:
            - ukmlib-includes-composerfile
            - composer

## PHP LIBRARIES SYMLINK TO PHP INCLUDES
/etc/php-includes/ICS:
  file.symlink:
    - target: /etc/php-libraries/vendor/mariusmandal/ics-gen/ICS
    - force: True

/etc/php-includes/PHPMailer:
  file.symlink:
    - target: /etc/php-libraries/vendor/phpmailer/phpmailer/src
    - force: True

/etc/php-includes/WPOO:
  file.symlink:
    - target: /etc/php-libraries/vendor/mariusmandal/wpoo
    - force: True

/etc/php-includes/lib:
  file.symlink:
    - target: /etc/php-libraries/vendor
    - force: True