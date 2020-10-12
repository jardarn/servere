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

    'roles:main':
        - match: grain
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