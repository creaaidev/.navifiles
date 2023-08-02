{ config, lib, pkgs, ... }:

let
  domain = "firefly.moniz.pt";
  env_file = pkgs.writeText "firefly.env" ''
# You can leave this on "local". If you change it to production most console commands will ask for extra confirmation.
# Never set it to "testing".
APP_ENV=local

# Set to true if you want to see debug information in error screens.
APP_DEBUG=false

# This should be your email address.
# If you use Docker or similar, you can set this variable from a file by using SITE_OWNER_FILE
# The variable is used in some errors shown to users who aren't admin.
SITE_OWNER=tsukuyomi@moniz.pt

# Firefly III will launch using this language (for new users and unauthenticated visitors)
# For a list of available languages: https://github.com/firefly-iii/firefly-iii/tree/main/resources/lang
#
# If text is still in English, remember that not everything may have been translated.
DEFAULT_LANGUAGE=en_US

# The locale defines how numbers are formatted.
# by default this value is the same as whatever the language is.
DEFAULT_LOCALE=equal

# Change this value to your preferred time zone.
# Example: Europe/Amsterdam
# For a list of supported time zones, see https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
TZ=Europe/Lisbon

# TRUSTED_PROXIES is a useful variable when using Docker and/or a reverse proxy.
# Set it to ** and reverse proxies work just fine.
TRUSTED_PROXIES=

# The log channel defines where your log entries go to.
# Several other options exist. You can use 'single' for one big fat error log (not recommended).
# Also available are 'syslog', 'errorlog' and 'stdout' which will log to the system itself.
# A rotating log option is 'daily', creates 5 files that (surprise) rotate.
# A cool option is 'papertrail' for cloud logging
# Default setting 'stack' will log to 'daily' and to 'stdout' at the same time.
LOG_CHANNEL=stack

#
# Used when logging to papertrail:
#
PAPERTRAIL_HOST=
PAPERTRAIL_PORT=

# Log level. You can set this from least severe to most severe:
# debug, info, notice, warning, error, critical, alert, emergency
# If you set it to debug your logs will grow large, and fast. If you set it to emergency probably
# nothing will get logged, ever.
APP_LOG_LEVEL=notice

# Audit log level.
# Set this to "emergency" if you dont want to store audit logs, leave on info otherwise.
AUDIT_LOG_LEVEL=info

# MySQL supports SSL. You can configure it here.
# If you use Docker or similar, you can set these variables from a file by appending them with _FILE
MYSQL_USE_SSL=false
MYSQL_SSL_VERIFY_SERVER_CERT=true
# You need to set at least of these options
MYSQL_SSL_CAPATH=/etc/ssl/certs/
MYSQL_SSL_CA=
MYSQL_SSL_CERT=
MYSQL_SSL_KEY=
MYSQL_SSL_CIPHER=

# If you're looking for performance improvements, you could install memcached or redis
CACHE_DRIVER=file
SESSION_DRIVER=file

# If you set either of the options above to 'redis', you might want to update these settings too
# If you use Docker or similar, you can set REDIS_HOST_FILE, REDIS_PASSWORD_FILE or
# REDIS_PORT_FILE to set the value from a file instead of from an environment variable

# can be tcp, unix or http
REDIS_SCHEME=tcp

# use only when using 'unix' for REDIS_SCHEME. Leave empty otherwise.
REDIS_PATH=

# use only when using 'tcp' or 'http' for REDIS_SCHEME. Leave empty otherwise.
REDIS_HOST=127.0.0.1
REDIS_PORT=6379

# Use only with Redis 6+ with proper ACL set. Leave empty otherwise.
REDIS_USERNAME=
REDIS_PASSWORD=

# always use quotes and make sure redis db "0" and "1" exists. Otherwise change accordingly.
REDIS_DB="0"
REDIS_CACHE_DB="1"

# Cookie settings. Should not be necessary to change these.
# If you use Docker or similar, you can set COOKIE_DOMAIN_FILE to set
# the value from a file instead of from an environment variable
# Setting samesite to "strict" may give you trouble logging in.
COOKIE_PATH="/"
COOKIE_DOMAIN=
COOKIE_SECURE=false
COOKIE_SAMESITE=lax

# If you use Docker or similar, you can set these variables from a file by appending them with _FILE
MANDRILL_SECRET=
SPARKPOST_SECRET=

# Firefly III can send you the following messages.
SEND_ERROR_MESSAGE=true

# These messages contain (sensitive) transaction information:
SEND_REPORT_JOURNALS=true

# Set this value to true if you want to set the location of certain things, like transactions.
# Since this involves an external service, it's optional and disabled by default.
ENABLE_EXTERNAL_MAP=false

# Set this value to true if you want Firefly III to download currency exchange rates
# from the internet. These rates are hosted by the creator of Firefly III inside
# an Azure Storage Container.
# Not all currencies may be available. Rates may be wrong.
ENABLE_EXTERNAL_RATES=false

# The map will default to this location:
MAP_DEFAULT_LAT=51.983333
MAP_DEFAULT_LONG=5.916667
MAP_DEFAULT_ZOOM=6

#
# Firefly III authentication settings
#

#
# Firefly III supports a few authentication methods:
# - 'web' (default, uses built in DB)
# - 'remote_user_guard' for Authelia etc
# Read more about these settings in the documentation.
# https://docs.firefly-iii.org/firefly-iii/advanced-installation/authentication
#
# LDAP is no longer supported :(
#
AUTHENTICATION_GUARD=web

#
# Remote user guard settings
#
AUTHENTICATION_GUARD_HEADER=REMOTE_USER
AUTHENTICATION_GUARD_EMAIL=

#
# Firefly III generates a basic keypair for your OAuth tokens.
# If you want, you can overrule the key with your own (secure) value.
# It's also possible to set PASSPORT_PUBLIC_KEY_FILE or PASSPORT_PRIVATE_KEY_FILE
# if you're using Docker secrets or similar solutions for secret management
#
PASSPORT_PRIVATE_KEY=
PASSPORT_PUBLIC_KEY=

#
# Extra authentication settings
#
CUSTOM_LOGOUT_URL=

# You can disable the X-Frame-Options header if it interferes with tools like
# Organizr. This is at your own risk. Applications running in frames run the risk
# of leaking information to their parent frame.
DISABLE_FRAME_HEADER=false

# You can disable the Content Security Policy header when you're using an ancient browser
# or any version of Microsoft Edge / Internet Explorer (which amounts to the same thing really)
# This leaves you with the risk of not being able to stop XSS bugs should they ever surface.
# This is at your own risk.
DISABLE_CSP_HEADER=false

# If you wish to track your own behavior over Firefly III, set valid analytics tracker information here.
# Nobody uses this except for me on the demo site. But hey, feel free to use this if you want to.
# Do not prepend the TRACKER_URL with http:// or https://
# The only tracker supported is Matomo.
# You can set the following variables from a file by appending them with _FILE:
TRACKER_SITE_ID=
TRACKER_URL=

#
# Firefly III supports webhooks. These are security sensitive and must be enabled manually first.
#
ALLOW_WEBHOOKS=false

# You can fine tune the start-up of a Docker container by editing these environment variables.
# Use this at your own risk. Disabling certain checks and features may result in lots of inconsistent data.
# However if you know what you're doing you can significantly speed up container start times.
# Set each value to true to enable, or false to disable.

# Set this to true to build all locales supported by Firefly III.
# This may take quite some time (several minutes) and is generally not recommended.
# If you wish to change or alter the list of locales, start your Docker container with
# `docker run -v locale.gen:/etc/locale.gen -e DKR_BUILD_LOCALE=true`
# and make sure your preferred locales are in your own locale.gen.
DKR_BUILD_LOCALE=false

# Check if the SQLite database exists. Can be skipped if you're not using SQLite.
# Won't significantly speed up things.
DKR_CHECK_SQLITE=true

# Run database creation and migration commands. Disable this only if you're 100% sure the DB exists
# and is up to date.
DKR_RUN_MIGRATION=true

# Run database upgrade commands. Disable this only when you're 100% sure your DB is up-to-date
# with the latest fixes (outside of migrations!)
DKR_RUN_UPGRADE=true

# Verify database integrity. Includes all data checks and verifications.
# Disabling this makes Firefly III assume your DB is intact.
DKR_RUN_VERIFY=true

# Run database reporting commands. When disabled, Firefly III won't go over your data to report current state.
# Disabling this should have no impact on data integrity or safety but it won't warn you of possible issues.
DKR_RUN_REPORT=true

# Generate OAuth2 keys.
# When disabled, Firefly III won't attempt to generate OAuth2 Passport keys. This won't be an issue, IFF (if and only if)
# you had previously generated keys already and they're stored in your database for restoration.
DKR_RUN_PASSPORT_INSTALL=true

# Leave the following configuration vars as is.
# Unless you like to tinker and know what you're doing.
APP_NAME=FireflyIII
BROADCAST_DRIVER=log
QUEUE_DRIVER=sync
CACHE_PREFIX=firefly
PUSHER_KEY=
IPINFO_TOKEN=
PUSHER_SECRET=
PUSHER_ID=
DEMO_USERNAME=
DEMO_PASSWORD=
FIREFLY_III_LAYOUT=v1

# Rest of config is in the age-encrypted file

  '';
in {
  age.secrets.firefly-env = {
    file = "${self}/nixos/secrets/firefly-env.age";
  };

  virtualisation.oci-containers.containers.firefly = {
    image = "firefly-iii/firefly-iii:latest";
    autoStart = true; # TODO: systemd service to start it with depends on postgresql?
    ports = [ "8081:8080" ];
    volumes = [
      "firefly_iii_upload:/var/www/html/storage/upload"
      "/run/postgresql:/run/postgresql"
    ];
    environmentFiles = [ env_file config.age.secrets.firefly-env.path ];
  };

  systemd.services.podman-firefly = {
    description = "Firefly III";
    after = [ "postgresql.service" ];
    wantedBy = [ "multi-user.target" ];
    };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    useACMEHost = "moniz.pt";
    locations."/".proxyPass = "http://127.0.0.1:8081";
  };
}
