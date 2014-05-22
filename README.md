sysmand
=======

Install sysmand
---------------
* cd /var/
* sudo git clone https://github.com/geeksen/sysmand.git
* cd sysmand
* sudo chown +x bin/sysmand
* sudo vi cfg/access.cfg
```
your.ip.address|My IP
```

* sudo chown www-data.www-data cfg
* sudo chown www-data.www-data cfg/*.cfg
* sudo mkdir script-enabled
* sudo chown www-data.www-data script-enabled
* sudo mkdir script-lock

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

Run
---
* sudo /etc/init.d/sysmand start
* ps -ef | grep sysmand
