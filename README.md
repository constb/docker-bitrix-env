# Standard Bitrix Environment on latest CentOS 6

Bitrix CMS contains features that require certain modules and settings. 1C provides a `bitrix-env`
shell script that automates installing and setting everything up on a clean CentOS 6 system. This
enables us to automate creation of a docker container with ready-to-run Bitrix CMS environment.

## TL;DR

This container is mostly based on [ewok/bitrix-env](https://github.com/ewok/dockerfiles/tree/master/bitrix-env)
although the image size is smaller (1.6G => 0.9G), legacy stuff is removed, added capability to run
in daemonized mode (`-d`) with no tty

#Ports

Ports that must be exposed in production environment are *80*, *443* for HTTP/HTTPS and *8893*, *8894*
for push notifications

Ports that can additionally be mapped are *22* and *3306* for SSH and MySQL respectively

## Volumes

Main volume to map is */home/bitrix/www* which serves as web root

Volume that can additionally be mapped is */var/lib/mysql* that holds file for MySQL database
although I recommend setting `NOMYSQL` and running DB in separate container

## Additional environment variables

  * `TIMEZONE` - put timezone name here, defaults to *Europe/Moscow*
  * `BVAT_MEM` - limits memory available to virtual environment in kB, defaults to *262144*
  * `NOMYSQL` - prevents starting MySQL inside container
  * `SSH_PASS` - sets password for `bitrix` user, defaults to *bitrix*

## Running

This container may run both in interactive mode (`docker run -it`) and daemonized (`docker run -d`)

This container supports overriding startup command (`docker run -it <name> /bin/bash`), but in this
case script that starts daemons won't run. So if you need to run shell inside an operational
Bitrix Environment, first start the container and then use `docker exec` to start a shell inside it

Container will shutdown gracefully when `docker stop` is issued

## Complete example

`docker run -d --name mysite -p 80:80 -p 2222:22 -p 443:443 -p 8893:8893 -p 8894:8894 -v /home/user/projects/mysite:/home/bitrix/www -e BVAT_MEM=524288 -e TIMEZONE="Asia/Novosibirsk" constb/bitrix-env`