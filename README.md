sysmand
=======

Daemonize sysmand
-----------------
* sudo cp /etc/init.d/skeleton /etc/init.d/sysmand
* sudo chmod +x /etc/init.d/sysmand
* sudo vi /etc/init.d/sysmand
```
# Provides:          sysmand

PATH=/sbin:/usr/sbin:/bin:/usr/bin
DESC="System Management Daemon"
NAME=sysmand
DAEMON=/var/sysmand/bin/$NAME
DAEMON_ARGS=
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
```

* update-rc.d sysmand defaults 99
* (update-rc.d -f sysmand remove)

