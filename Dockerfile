FROM ubuntu:14.04.2

MAINTAINER aptalca

VOLUME ["/config"]

EXPOSE 80

RUN export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive && \
sudo apt-get update && \
sudo apt-get install -y software-properties-common \
python-software-properties && \
sudo add-apt-repository -y ppa:iconnor/zoneminder && \
sudo apt-get update && \
sudo apt-get install -y \
wget \
apache2 \
mysql-server \
php5 \
libapache2-mod-php5 && \
service apache2 restart && \
service mysql restart && \
apt-get install -y \
zoneminder \
libvlc-dev \
libvlccore-dev vlc && \
a2enmod cgi && \
sudo service apache2 restart && \
sudo service mysql restart && \
rm -r /etc/init.d/zoneminder && \
mkdir -p /etc/my_init.d

ADD zoneminder /etc/init.d/zoneminder
ADD firstrun.sh /etc/my_init.d/firstrun.sh

RUN sudo chmod +x /etc/init.d/zoneminder && \
mkdir /etc/apache2/conf.d && \
ln -s /etc/zm/apache.conf /etc/apache2/conf.d/zoneminder.conf && \
ln -s /etc/zm/apache.conf /etc/apache2/conf-enabled/zoneminder.conf && \
sudo adduser www-data video && \
sudo service apache2 restart && \
cd /usr/src && \
wget http://www.charliemouse.com:8080/code/cambozola/cambozola-0.936.tar.gz && \
tar -xzvf cambozola-0.936.tar.gz && \
cp cambozola-0.936/dist/cambozola.jar /usr/share/zoneminder && \
cp /etc/zm/apache.conf /root/apache.conf && \
cp /etc/zm/zm.conf /root/zm.conf && \
sudo chmod +x /etc/my_init.d/firstrun.sh && \
sudo update-rc.d -f apache2 remove && \
sudo update-rc.d -f mysql remove && \
sudo update-rc.d -f zoneminder remove
