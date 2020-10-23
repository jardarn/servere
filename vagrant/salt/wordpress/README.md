Wordpress-config er satt i flere filer

Standard-data er satt i pillar/wordpress/init.sls
Siden databaseinfo ikke nødvendigvis er unikt for wordpress, kan du også definere db-connection via defaults i init.sls

**pillar**
```yaml
{}
wordpress:
    version: 5.5.1
    language: 'nb_NO'
    fs_method: 'direct'
    debug: false
    multisite: true
    subdomain_install: false
    current_site:
        domain: 
        path: 
        blog_id: 1
        site_id: 1
    database:
        name: 
        user:
        pass: 
        host: localhost
        charset: utf8
        collate: ''
        prefix: 'wp_'

    auth_key: ''
    secure_auth_key: ''
    logged_in_key: ''
    nonce_key: ''
    auth_salt: ''
    secure_auth_salt: ''
    logged_in_salt: ''
    nonce_salt: ''
```


**Opprette wp-config.php**
Dette skjer ikke automatisk, og må gjøres fra en state utenfor wordpress. 
Defaults som ikke er satt her, vil bruke pillar.wordpress-info.

```yaml
wordpress-config:
    file.managed:
        - name: /var/www/wordpress/wp-config.php
        - source: salt://wordpress/files/wp-config.php
        - template: jinja
        - defaults:
            database_name:
            database_user:
            database_pass:
            database_host:
            database_charset:
            database_collate: 
            database_table_prefix: 
            current_site_domain: ukm.dev
            current_site_path: /
            current_site_id: 1
            current_site_blog_id: 1
``` 