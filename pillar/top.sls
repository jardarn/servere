base:
    '*':
        - java
        - mysql
        - ssl
        - videoconverter

    'phpweb':
        - php
        - composer

    'roles:lite':
        - match: grain
        - ukmlib

    'roles:main':
        - match: grain
        - ukmlib
        - ukmno

    'vagrant':
        - samba