php-imagick:
    pkg.installed:
        - name: php-imagick
        - require:
            - pkg: apache
            - pkg: mod-php