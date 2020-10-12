base:
    '*':
        - networking
        - security
        - vim
        - swap

    'vagrant':
        - samba

    'phpweb':
        - composer

    'roles:lite':
        - match: grain
        - ukmlib

    'roles:main':
        - match: grain
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