subdomains:
    assets:
        subdomain: assets
        github: https://github.com/UKMNorge/UKMDesignAssets.git
        composer: false
    id:
        subdomain: id
        github: https://github.com/UKMNorge/ID.git
        composer: false
    api:
        subdomain: api
        github: https://github.com/UKMNorge/UKMapi_public.git
        composer: false
    delta:
        subdomain: delta
        github: https://github.com/UKMNorge/UKMDelta.git
        composer: true
        document_root: /var/www/delta/web/
        parameters: 
            target: /var/www/delta/app/config/parameters.yml
            source: salt://ukmbox-main/files/params-delta.yml.j2
    graphite:
        subdomain: graphite
        github: https://github.com/UKMNorge/Graphite.git
        composer: true
    husk:
        subdomain: husk
        github: https://github.com/UKMNorge/UKMhusk.git
        composer: true
        document_root: /var/www/husk/web/
        parameters:
            target: /var/www/husk/app/config/parameters.yml
            source: salt://ukmbox-main/files/params-husk.yml.j2
    pressemelding:
        subdomain: pressemelding
        github: https://github.com/UKMNorge/UKMpressemelding.git
        composer: true
        document_root: /var/www/pressemelding/web/
        parameters:
            target: /var/www/pressemelding/app/config/parameters.yml
            source: salt://ukmbox-main/files/params-pressemelding.yml.j2
    sms:
        subdomain: sms
        github: https://github.com/UKMNorge/UKMsms_recieve.git
    slack:
        subdomain: slack
        github: https://github.com/UKMNorge/Slack.git

    # TV and its subdomains
    tv:
        subdomain: tv
        github: https://github.com/UKMNorge/UKMTV.git
        composer1: true
        document_root: /var/www/tv/public/
    embed:
        subdomain: embed
        github: https://github.com/UKMNorge/UKMTV-Embed
    oembed:
        subdomain: oembed
        github: https://github.com/UKMNorge/UKMTV_oEmbed
    cache: 
        subdomain: cache
        github: https://github.com/UKMNorge/UKMTV_cache