wordpress-plugin-cache-dir:
    file.directory:
        - name: /home/ukmno/public_html/cache_twig
        - mode: 777
        - makedirs: True
        - require:
            - https://github.com/UKMNorge/UKMcache.git
