{% set ukm = pillar.get('ukm', {}) %}

include:
    - apache
    - ssl
    - composer
    - ukmlib.config
    - ukmlib.includes

ukmlib-deps:
    pkg.installed:
        - pkgs:
            - git
            - php7.2-curl
            - unzip
    file.directory:
        - name: /etc/php-includes