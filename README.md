This build a base Ubuntu Natty system that has the following infrastructure:

 1. nginx       - web
 2. supervisord - process management
 3. redis       - persistent caching
 4. memcached   - transient caching
 5. uwsgi       - wsgi application server

# Principles

1. Start from a fresh Natty install
2. Build a common starting point for a web service root
4. Enable local deployment within a VM

# Installation

As root run:

    curl https://raw.github.com/ericmoritz/ubuntu-natty-web/master/bootstrap.sh | bash

This will do the following:

 1. checkout the latest version of ubuntu-natty-web to /opt/ubuntu-natty-web
 2. Install base services and packages

# Development pattern

Using this allows me to deploy a project quickly to a common starting point.

## Projects

Your project must be developed external to this system and provide a
build script that starts with the assumption of a null server state.

Let's create a build-site.sh script:


    mkdir ~/project
    cd ~/project
    echo 'Hello, World!' > hello.txt
    cat > build-site.sh << EOF
    cp ~/project/hello.txt static/
    EOF


This creates a new build-site.sh who's job is to create a static hello.txt 
file.

This script acts is a bootstrap to pull your project's resources into
the server's null state.  In this example, we are generating the
resource but in practice the resources will be pulled in via a version
control system

## Deploying a project

Now that we have a usable build-site.sh script. we can create a new
service using this project.

    cd /opt/ubuntu-natty-web/
    ./mksite.sh example.com
    
This creates a /var/www/servers/example.com/ directory.

By default the only thing a new service does is serve
content out of it's static/ directory.

Let's deploy our project to this service

    cd /var/www/servers/example.com
    bash ~/project/build-site.sh

Now restart nginx to pick up the new site's etc/nginx.conf file 

    sudo /etc/nginx.conf

We will now be able to curl our hello.txt file

    curl -H "Host: example.com" http://localhost/hello.txt
    # => Hello, World!

That's about it.  You're responsible to set up DNS and Networking.

# Platform shortcuts

## Python / WSGI

Currently there is a shortcut for setting up a server for serving WSGI
apps. In the the shortcuts/uwsgi directory there is a install.sh
script that configures uwsgi and supervisord for running a wsgi app.

By default the uwsgi shortcut configures uwsgi to set the PWD to code/app.
This enables you to create simple single module services with little
effort using your microframework of choice.

More complex projects should use virtualenv and python deployment tools to
install your project or derive a shortcut from the built in uwsgi
shortcut. For instance, one such shortcut could be a Django shortcut,
Pyramid, or other framework.

## Installing the uwsgi shortcut

To install the uwsgi shortcut, do the following:

    cd /opt/ubuntu-natty-web/shortcuts/uwsgi
    ./install.sh example.com hello hello:application

This creates the neccessary configuration for a WSGI service called "hello"
that exists as the python module hello.application.

## hello.py

Let's modify our hello project to be a WSGI application called hello.application
that dynamically says "Hello, World!":

      cd ~/project
      mkdir -p code/app/
      cat > code/app/hello.py << EOF
      def application(enivron, start_response):
            start_response("200 OK", [("Content-Type", "text/plain")])
            return ["Hello, World!"]
      EOF
      # Rewrite our build-site.sh      
      cat > build-site.sh << EOF
      cp -R ~/project/code/app ./code/app/

Now let's deploy our WSGI app:

    cd /var/www/servers/example.com/
    ~/project/build.sh

Update supervisord to pick up the new configuration:
    
    supervisorctl update

Now we should have a running service:

    curl -H "Host: example.com" http://localhost/
    # => Hello, World!

The uwsgi shortcut reroutes the static content to /static/
