ukmtv-temp-dir:
    file.directory:
        - name: /tmp/symfony/ukmtv/
        - makedirs: True
        - user: www-data
        - group: www-data
        - mode: '0777'
        - dir_mode: 777
        - recurse:
            - user
            - group
            - mode

ukmtv-cache-cert:
    file.managed:
        - name: /etc/apache2/tvcaches.crt
        - contents_pillar: ukmtv.cache.cert

ukmtv-cache-key:
    file.managed:
        - name: /etc/apache2/tvcaches.key
        - contents_pillar: ukmtv.cache.key
        - user: root
        - group: www-data
        - mode: 640