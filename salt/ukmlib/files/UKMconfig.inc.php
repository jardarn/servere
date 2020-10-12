{% set ukmlib = pillar.get('ukmlib') %}
{% set ukm = ukmlib.ukm -%}
{% set apis = ukmlib.apis -%}
{% set videoconverter = pillar.get('videoconverter', {}) -%}
{% set cache_key = pillar['tvcache.shared_key'] -%}

<?php

define('UKM_HOSTNAME', '{{ ukm.hostname }}');
define('UKM_SALT', '{{ukm.genericsalt}}');

## EMAIL SETTINGS
define('UKM_MAIL_HOST', '{{ ukm.mail.host }}');
define('UKM_MAIL_USER', '{{ ukm.mail.user }}');
define('UKM_MAIL_PASS', '{{ ukm.mail.pass }}');
define('UKM_MAIL_PORT', '{{ ukm.mail.port }}');
define('UKM_MAIL_FROM', '{{ ukm.mail.from.address }}');
define('UKM_MAIL_FROMNAME', '{{ ukm.mail.from.name }}');
define('UKM_MAIL_REPLY', '{{ ukm.mail.reply }}');

## DATABASE

# UKM-DB
define('UKM_DB_HOST', '{{ ukm.database.host }}');
define('UKM_DB_NAME', '{{ ukm.database.ss3.name }}');
define('UKM_DB_USER', '{{ ukm.database.ss3.users.user_read.name }}');
define('UKM_DB_PASSWORD', '{{ ukm.database.ss3.users.user_read.pass }}');
define('UKM_DB_WRITE_USER', '{{ ukm.database.ss3.users.user_write.name }}');
define('UKM_DB_WRITE_PASSWORD', '{{ ukm.database.ss3.users.user_write.pass }}');

# WP-DB
define('UKM_WP_DB_HOST', '{{ ukm.database.host }}');
define('UKM_WP_DB_NAME', '{{ ukm.database.wp.name }}');
define('UKM_WP_DB_USER', '{{ ukm.database.wp.users.user_read.name }}');
define('UKM_WP_DB_PASSWORD', '{{ ukm.database.wp.users.user_read.pass }}');
define('UKM_WP_DB_WRITE_USER', '{{ ukm.database.wp.users.user_write.name }}');
define('UKM_WP_DB_WRITE_PASSWORD', '{{ ukm.database.wp.users.user_write.pass }}');

# DELTA-DB
define('UKM_DELTA_DB_HOST', '{{ ukm.database.host }}');
define('UKM_DELTA_DB_NAME', '{{ ukm.database.delta.name }}');
define('UKM_DELTA_DB_USER', '{{ ukm.database.delta.users.user_read.name }}');
define('UKM_DELTA_DB_PASSWORD', '{{ ukm.database.delta.users.user_read.pass }}');
define('UKM_DELTA_DB_WRITE_USER', '{{ ukm.database.delta.users.user_write.name }}');
define('UKM_DELTA_DB_WRITE_PASSWORD', '{{ ukm.database.delta.users.user_write.pass }}');

# VIDEOCONVERTER
define('UKM_VIDEOCONVERTER_DB_USER', '{{ videoconverter.database.user }}');
define('UKM_VIDEOCONVERTER_DB_PASS', '{{ videoconverter.database.pass }}');
/* Shared secret needed to upload to the videostorage server */
define('UKM_VIDEOSTORAGE_UPLOAD_KEY', '{{ videoconverter.keys.upload }}');
/* Shared secret needed for caches to report in, or to fetch the cache listing */
define('UKM_CACHE_KEY', '{{ videoconverter.keys.cache }}');

## EXTERNAL APIS
# SVEVE
define('UKM_SVEVE_ACCOUNT', '{{apis.sveve.account}}');

# LIVESTREAM
define('LIVESTREAM_EMAIL','{{apis.livestream.email}}');

# FACEBOOK
define('UKM_FACE_APP_ID', '{{ apis.facebook.app.id}}');
define('UKM_FACE_APP_SECRET', "{{ apis.facebook.app.secret }}");

# GOOGLE
define('GOOGLE_API_KEY', '{{ apis.google.key}}');

# MAILCHIMP
define('MAILCHIMP_API_KEY', '{{ apis.mailchimp.key');
define('MAILCHIMP_LIST_ID_ARRANGOR','{{ apis.mailchimp.lists.arrangor }}');

# TRELLO
define('TRELLO_APP_KEY', '{{ apis.trello.app.key }}');
define('TRELLO_APP_TOKEN', '{{ apis.trello.app.token }}');

# TRELLO: /kjøp
define('TRELLO_BOARD_INNKJOP', '{{ apis.trello.boards.innkjop }}');
define('TRELLO_CUSTOM_LEVERES', '{{ apis.trello.custom_fields.leveres }}');

# INSTRATO
define('INSTAGRAM_CLIENT_ID', '{{ apis.instagram.client.id }}');
define('INSTAGRAM_CLIENT_SECRET', '{{ apis.instagram.client.secret }}');
define('INSTAGRAM_AUTHORIZATION_REDIRECT_URI', '{{ apis.instagram.client.auth_redirect }}');

# FLICKR
define('FLICKR_API_KEY', '{{ apis.flickr.app.key}}');
define('FLICKR_API_SECRET', '{{ apis.flickr.app.secret}}');
define('FLICKR_ENDPOINT', '{{ apis.flickr.app.endpoint }}');

define('FLICKR_AUTH_USER', '{{ apis.flickr.user.id }}');
define('FLICKR_AUTH_TOKEN', '{{ apis.flickr.user.token }}');
define('FLICKR_AUTH_SECRET', '{{ apis.flickr.secret }}');

# DROPBOX
define('DROPBOX_APP_NAME', '{{ apis.dropbox.app.name }}');
define('DROPBOX_APP_ID', '{{ apis.dropbox.app.id }}');
define('DROPBOX_APP_SECRET', '{{ apis.dropbox.app.secret }}');
define('DROPBOX_ENDPOINT', '{{ apis.dropbox.app.endpoint }}');
define('DROPBOX_AUTH_ACCESS_TOKEN', '{{ apis.dropbox.user.token }}');

// CLOUDFLARE
define('UKM_CLOUDFLARE_AUTH_KEY', '{{ apis.cloudflare.auth_key }}');
define('UKM_CLOUDFLARE_EMAIL', '{{ apis.cloudflare.email }}');
define('UKM_CLOUDFLARE_UKMNO_ZONE', '{{ apis.cloudflare.zone }}');
define('UKM_CLOUDFLARE_URL', '{{ apis.cloudflare.url }}');

// INSTRATO
define('UKM_INSTRATO_PEPPER', '@90#%');
define('UKM_INSTRATO_SALT', 'UKMhash');

# SLACK
define('SLACK_CLIENT_ID', '{{ slack.client.id }}');
define('SLACK_CLIENT_SECRET', '{{ slack.client.secret }}');
define('SLACK_SIGNING_SECRET', '{{ slack.client.signing_secret }}');
define('SLACK_SHAREABLE_URL', '{{ slack.client.shareable_url }}');
define('SLACK_UKMNORGE_TEAM_ID', '{{ slack.teams.ukmnorge }}');
define('SLACK_UKMMEDIA_TEAM_ID', '{{ slack.teams.ukmmedia }}');

## FILER
# BILDER
define('UKM_BILDER_SYNC_FOLDER', '{{ ukm.bilder.sync_folder }}');

# DOWNLOAD PATHS
define('DOWNLOAD_PATH', (UKM_HOSTNAME == 'ukm.dev' ? '/var/www' : '/home/ukmno/public_subdomains') .'/download/');
define('DOWNLOAD_PATH_EXCEL', DOWNLOAD_PATH . 'excel/');
define('DOWNLOAD_PATH_WORD', DOWNLOAD_PATH . 'word/');
define('DOWNLOAD_PATH_ZIP', DOWNLOAD_PATH . 'zip/');
define('DOWNLOAD_PATH_CSV', DOWNLOAD_PATH . 'csv/');

define('DOWNLOAD_URL', 'http://download.'. UKM_HOSTNAME .'/');
define('DOWNLOAD_URL_EXCEL', DOWNLOAD_URL .'excel/');
define('DOWNLOAD_URL_WORD', DOWNLOAD_URL .'word/');
define('DOWNLOAD_URL_ZIP', DOWNLOAD_URL .'zip/');
define('DOWNLOAD_URL_CSV', DOWNLOAD_URL .'csv/');