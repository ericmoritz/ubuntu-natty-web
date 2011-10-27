##
# Configure redis
##
# backup the redis.conf
cp /etc/redis/redis.conf /etc/redis/redis-$DATE.conf

# Change appendonly to true
cat /etc/redis/redis.conf | sed 's/appendonly no/appendonly yes/' > /etc/redis/redis.conf

##
# Setup the web roots
##
mkdir -p /var/www/servers

##
# Copy supervisor.ini to /etc/
cp etc/supervisord.conf /etc/
mkdir /etc/supervisord.d