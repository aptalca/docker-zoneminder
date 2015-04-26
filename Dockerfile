FROM phusion/baseimage:0.9.11

MAINTAINER aptalca

VOLUME ["/config"]

EXPOSE 80

RUN echo $TZ > /etc/timezone && \
export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
dpkg-reconfigure tzdata && \
add-apt-repository ppa:iconnor/zoneminder && \
apt-get update && \
apt-get install -y \
wget \
apache2 \
mysql-server \
php5 \
libapache2-mod-php5 \
software-properties-common \
python-software-properties \
zoneminder \
libvlc-dev \
libvlccore-dev vlc && \
rm /etc/init.d/zoneminder && \
a2enmod cgi && \
service mysql restart && \
mysql -e "create database zm" && \
mysql zm < db/zm_create.sql && \
mysql zm -e "grant select,insert,update,delete,lock tables,alter on zm.* to 'zmuser'@localhost identified by 'zmpass'" && \
mysqladmin reload

ADD zoneminder /etc/init.d/zoneminder
ADD firstrun.sh /root/firstrun.sh

RUN chmod +x /etc/init.d/zoneminder && \
chmod +x /root/firstrun.sh && \
mkdir /etc/apache2/conf.d && \
ln -s /etc/zm/apache.conf /etc/apache2/conf.d/zoneminder.conf && \
ln -s /etc/zm/apache.conf /etc/apache2/conf-enabled/zoneminder.conf && \
adduser www-data video && \
service apache2 restart && \
cd /usr/src && \
wget http://www.charliemouse.com:8080/code/cambozola/cambozola-0.936.tar.gz && \
tar -xzvf cambozola-latest.tar.gz && \
cp cambozola-0.936/dist/cambozola.jar /usr/share/zoneminder && \
cp /etc/zm/apache.conf /root/apache.conf && \
cp /etc/zm/zm.conf /root/zm.conf && \
rm -r /etc/zm

CMD /root/firstrun.sh
