{% set ukmwordpress = pillar.get('ukmwordpress', {}) %}

## ADD GITHUB PLUGINS
{% if ukmwordpress.plugins is defined %}
    {% for repo in ukmwordpress.plugins %}
https://github.com/UKMNorge/{{ repo }}.git:
    git.latest:
        - target: /var/www/wordpress/wp-content/plugins/{{ repo }}
        - require:
            - wordpress-install
    {% endfor %}
{% endif %}

## ADD NON-GITHUB PLUGINS
ukm-wordpress-plugins:
    file.managed:
        - name: /usr/local/src/ukmwpplugins.tar.gz
        - source: http://dev.ukm.no/vagrant/ukmwpplugins.tar.gz
        - source_hash: sha1=a5ee8b5902dea76a1debbe8296ae2a3fc4305ee4

    cmd.wait:
        - name: tar xf /usr/local/src/ukmwpplugins.tar.gz -C /var/www/wordpress/wp-content/plugins --strip 1 --no-same-permissions --no-same-owner
        - watch:
            - file: ukm-wordpress-plugins

include:
    - ukmbox-main.plugins.cache