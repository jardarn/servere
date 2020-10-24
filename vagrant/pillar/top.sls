base:
    '*':
        - java
        - mysql
        - ssl
        - ukmtv

    'phpweb':
        - php
        - composer

    'roles:lite':
        - match: grain
        - ukm

    'roles:main':
        - match: grain
        - ukm
        - wordpress
        - ukmtv
    
    'roles:playback':
        - match: grain
        - ukm

    'vagrant':
        - samba