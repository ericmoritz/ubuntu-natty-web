
if [ "$1x" = "x" ]; then
    echo "usage: $0 [domain]"
    exit
fi

DOMAIN=$1
ROOT=/var/www/servers/$1


# Copy the wwwroot.conf to /etc/nginx/conf.d/
# to enable /var/www/servers/*/etc/nginx.conf's
cp ./etc/nginx_wwwroot.conf  /etc/nginx/conf.d/wwwroot.conf

mkdir -p $ROOT
cp -R ./wwwroot/* $ROOT/

# Make the host substitutions for the nginx config
sed "s/{{HOST}}/$DOMAIN/" wwwroot/etc/nginx.conf > $ROOT/etc/nginx.conf
sed "s/{{HOST}}/$DOMAIN/" wwwroot/etc/supervisord.conf > $ROOT/etc/supervisord.conf

# chown www-data to www-data
chown www-data.www-data $ROOT/www-data

echo "Created $1 @ $ROOT"
