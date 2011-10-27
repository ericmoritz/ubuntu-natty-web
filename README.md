This build a base Ubuntu Natty system that has the following infrastructure:

 1. nginx       - web
 2. supervisord - process management
 3. redis       - persistent caching
 4. memcached   - transient caching
 5. uwsgi       - wsgi application server

# Commands

 1. setup.sh  - installs the base system
 2. mksite.sh - creates a new server root at /var/www/servers/

# Server config

A site's initial config does only one thing.  Server static content out
of it's static/ directory.

Dynamic content will need to do two things

 1. Create a etc/supervisord.ini that starts the needed application services
 2. Config etc/nginx-site.conf to proxy to those services

# Local Development

This system is designed to enable local develop and simple deployment.

## Create Site

./mksite.sh [domain]

This creates a new web server root at /var/www/servers/ identified by
[domain]

## Create UWSGI service

To create a uwsgi service do the following

./shortcuts/uwsgi/install.sh [domain] [service] [module:app]

Service is a name for the service and module:app is the wsgi module and wsgi
app.

## Custom long running processes

This system use supervisord to manage long running processes per server.

Place your supervisord.d in server's etc/supervisord.d/ directory

# Server Deployment

Each server have ./build-site.sh which handles the building of
the service.

Things that this script is responsible would be downloading
dependancies, checking out code, rendering static content, etc.

## Remote server setup

From a Ubuntu null state run

   sudo curl https://github.com/ericmoritz/ubuntu-natty-web/raw/master/bootstrap.sh | sh




