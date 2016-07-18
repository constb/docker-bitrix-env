#!/bin/sh
# Note: Entry point to birix container

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "shut_down" HUP INT QUIT KILL TERM

shut_down(){
# stop service and clean up here

if [[ $NOMYSQL == 1 ]];
then
    echo "No sql"
else
    service mysqld stop
fi

service nginx stop
service httpd stop
service sshd stop
service crond stop

}

# start service in background here
# memory=${BVAT_MEM:=262144}

/etc/init.d/bvat start

if [[ $NOMYSQL == 1 ]];
then
    echo "No sql"
else
    service mysqld start
fi

if [ ! -z "$TIMEZONE" ];
then
    cp -f /usr/share/zoneinfo/$TIMEZONE /etc/localtime
fi

service crond start
service httpd start
service nginx start
service sshd start

echo "bitrix:$SSH_PASS" | chpasswd

echo "[hit ctrl-c to exit] or run 'docker stop <container>'"
while true; do sleep 1; done

shut_down

echo "exited $0"

