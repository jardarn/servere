base:
    '*':
        - networking
        - security
        - ssl
        - vim
        - swap

    'vagrant':
        - samba

    'roles:phpweb':
        - match: grain
        - apache
        - composer
    
    'roles:database':
        - match: grain
        - mysql

    'roles:ukmbox':
        - match: grain
        - ukmbox

    'roles:lite':
        - match: grain
        - ukmlib
        - ukmbox-lite

    'roles:main':
        - match: grain
        - ukmlib
        - wordpress
        - ukmbox-main
        - nodejs
    
    'roles:playback':
        - match: grain
        - ukmbox-playback
   
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