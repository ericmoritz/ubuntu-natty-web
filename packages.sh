apt-get install python-software-properties

# Install all the ppa's
add-apt-repository ppa:nginx/stable
add-apt-repository ppa:uwsgi/release

# Refresh apt
apt-get update

# Install all the base packages
apt-get install git nginx redis-server memcached build-essential python-dev emacs python-setuptools git mercurial
easy_install pip virtualenv supervisor

DATE=`date +%Y-%m-%dT%T`
