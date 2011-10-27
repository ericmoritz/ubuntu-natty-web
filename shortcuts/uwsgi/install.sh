DOMAIN=$1
SERVICE=$2
MODULE=$3
ROOT=/var/www/servers/$DOMAIN

if [ "x$DOMAIN$SERVICE$MODULE" == "x" ]; then
    echo "Usage $0 [domain] [service] [module]"
    exit
fi

render() {
  FILEPATH=$1
  FILEDIR=`dirname "$FILEPATH"`
  FILENAME=`basename "$FILEPATH"`
  TEMPLATE=${FILEPATH}

  sed "s/{{domain}}/${DOMAIN}/;s/{{service}}/${SERVICE}/;s/{{module}}/${MODULE}/" $TEMPLATE
}

cp -R etc $ROOT/
render etc/nginx.d/uwsgi.conf_tmpl > $ROOT/etc/nginx.d/${SERVICE}_uwsgi.conf
render etc/supervisord.d/uwsgi.ini_tmpl > $ROOT/etc/supervisord.d/${SERVICE}_uwsgi.ini
render etc/uwsgi/uwsgi.ini_tmpl > $ROOT/etc/uwsgi/${SERVICE}.ini

# Create the data root
mkdir -p $ROOT/www-data/data/${SERVICE}
chown -R www-data.www-data $ROOT/www-data/data/${SERVICE}