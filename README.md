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

