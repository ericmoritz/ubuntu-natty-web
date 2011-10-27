This build a base Ubuntu Natty system that has the following infrastructure:

 1. nginx       - web
 2. supervisord - process management
 3. redis       - persistent caching
 4. memcached   - transient caching
 5. uwsgi       - wsgi application server

# Principles

1. Start from a null state.
2. Build a common platform for a web service root
3. A web service root is itself a null state for the apps to start from
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
    echo "Hello, World" > hello.txt
    cat > build-site.sh < EOF
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

If nginx is running, we will now be able to curl
our hello.txt file

    curl -H "Host: example.com" http://localhost/hello.txt

That's about it.
    

