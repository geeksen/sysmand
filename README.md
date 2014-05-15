sysmand
=======

Install sysmand
---------------
* cd /var/
* sudo git clone https://github.com/geeksen/sysmand.git
* cd sysmand
* sudo chown +x bin/sysmand
* sudo chown 705 cgi/sysmand.cgi
* sudo mkdir script-enabled
* sudo mkdir script-lock
* sudo mkdir script-log

Check Perl Path
---------------
* which perl
```
/usr/bin/perl
```

* (if necessary, modify the first line of source code)
* sudo vi bin/sysmand cgi/sysmand.cgi
```perl
#!/usr/bin/perl
```

Daemonize sysmand
-----------------
* sudo cp /etc/init.d/skeleton /etc/init.d/sysmand
* sudo chmod +x /etc/init.d/sysmand
* sudo vi /etc/init.d/sysmand
```
# Provides:          sysmand
..
PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="System Management Daemon"
NAME=sysmand
DAEMON=/var/sysmand/bin/$NAME
DAEMON_ARGS=
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
```

* sudo update-rc.d sysmand defaults 99
* (sudo update-rc.d -f sysmand remove)

Enable CGI
----------
* sudo a2enmod cgi
* cd /etc/apache2/mods-available
* sudo vi mime.conf
```
AddHandler cgi-script .cgi
```

* cd /etc/apache2/sites-enabled
* sudo vi 000-default
```
<Directory /var/www>
Options ExecCGI ..
..
</Directory>
```

* sudo /etc/init.d/apache2 restart
* cd /var/www
* sudo ln -s /var/sysmand/cgi ./sysmand

Run
---
* sudo /etc/init.d/sysmand start
* ps -ef | grep sysmand
* Go to http://your.web.server/sysmand/sysmand.cgi
