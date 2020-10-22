{% set subdomains = pillar.get('subdomains', {}) %}

{% for subdomain, conf in subdomains %}
ukm-subdomain-{{subdomain}}:
    file.directory:
         - name: /var/www/{{subdomain}}/

{% if conf.github is defined and conf.github %}
ukm-subdomain-{{subdomain}}-git:
    git.latest:
        - name: {{conf.github}}
        - target: /var/www/{{subdomain}}
        - require:
            - pkg: ukmlib
{% endif %}

{% if conf.composer is defined and conf.composer %}
ukm-subdomain-{{subdomain}}-composer:
    cmd.run:
        - name: composer install
        - cwd: /var/www/{{subdomain}}
        - require:
            - ukm-subdomain-{{subdomain}}
            - composer
{% endif %}

ukm-subdomain-{{subdomain}}-vhost:
    file.managed:
        - name: /etc/apache2/sites-enabled/api.conf
        - source: salt://ukmno/files/vhost-subdomain.conf
        - template: jinja
        - defaults:
          subdomain: api
        - watch_in:
            - service: apache
        - require:
            - ssl-key-ukm-dev
{% endfor %}