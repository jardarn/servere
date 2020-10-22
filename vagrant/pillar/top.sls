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
        - ukm

    'roles:main':
        - match: grain
        - ukm

    'vagrant':
        - samba