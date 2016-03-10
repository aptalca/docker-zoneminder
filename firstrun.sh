#!/bin/bash
  
  #Search for config files, if they don't exist, copy the default ones
  if [ ! -f /config/php.ini ]; then
    echo "copying php.ini"
    cp  /etc/php5/apache2/php.ini /config/php.ini
  else
    echo "php.ini already exists"
    cp /config/php.ini /etc/php5/apache2/php.ini
  fi
  
  # Copy mysql database if it doesn't exit
  if [ ! -d /config/mysql/mysql ]; then
    echo "moving mysql to config folder"
    rm -r /config/mysql
    cp -p -R /var/lib/mysql /config/
  else
    echo "using existing mysql database"
  fi
  
  # Copy data folder if it doesn't exist
  if [ ! -d /config/data ]; then
    echo "moving data folder to config folder"
    mkdir /config/data
    mkdir /config/data/images
    mkdir /config/data/events
    mkdir /config/data/temp
  else
    echo "using existing data directory"
  fi
  
  if [ ! -d /config/perl5 ]; then
    echo "moving perl data folder to config folder"
    mkdir /config/perl5
    cp -R -p /usr/share/perl5/ZoneMinder /config/perl5/
  else
    echo "using existing perl data directory"
  fi

  
  echo "creating symbolink links"
  rm -r /usr/share/zoneminder/events
  rm -r /usr/share/zoneminder/images
  rm -r /usr/share/zoneminder/temp
  rm -r /var/lib/mysql
  rm -r /usr/share/perl5/ZoneMinder
  ln -s /config/data/events /usr/share/zoneminder/events
  ln -s /config/data/images /usr/share/zoneminder/images
  ln -s /config/data/temp /usr/share/zoneminder/temp
  ln -s /config/mysql /var/lib/mysql
  ln -s /config/perl5/ZoneMinder /usr/share/perl5/ZoneMinder
  chown -R mysql:mysql /var/lib/mysql
  chown -R www-data:www-data /config/data
  chmod -R go+rw /config
  
  #Get docker env timezone and set system timezone
  echo "setting the correct local time"
  echo $TZ > /etc/timezone
  export DEBCONF_NONINTERACTIVE_SEEN=true DEBIAN_FRONTEND=noninteractive
  dpkg-reconfigure tzdata
  
  #fix memory issue
  echo "increasing shared memory"
  umount /dev/shm
  mount -t tmpfs -o rw,nosuid,nodev,noexec,relatime,size=${MEM:-4096M} tmpfs /dev/shm
  
  echo "starting services"
  service mysql start
  service apache2 start
  service zoneminder start
