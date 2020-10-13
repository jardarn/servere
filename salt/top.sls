base:
    '*':
        - networking
        - security
        - ssl
        - vim
        - swap
        - ukmboxes

    'vagrant':
        - samba

    'phpweb':
        - composer
        - mysql

    'roles:lite':
        - match: grain
        - mysql
        - ukmlib

    'roles:main':
        - match: grain
        - mysql
        - ukmlib
        - ukmno
   
    'roles:videoconverter':
        - match: grain
        - ffmpeg
        - videoconverter

    'roles:videostorage':
        - match: grain
        - videostorage

    'roles:videocache':
        - match: grain
        - wowza
    
    'roles:playback':
        - match: grain
        - ukmplayback