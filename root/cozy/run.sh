#!/bin/sh

[ -z "${UID}" ] && UID=1500
[ -z "${GID}" ] && GID=1500
[ -z "${RUN_AS_ROOT}" ] && RUN_AS_ROOT=0

if [ $(cat /etc/passwd | grep -c cozy) != 1 ]; then
    addgroup -g ${GID} cozy
    adduser -h /cozy -G cozy -D -H -u ${UID} cozy
    chown cozy:cozy /cozy/cozy-stack
    chown -R cozy:cozy /cozy/config
fi

if [ ${RUN_AS_ROOT} = 1 ]; then
    echo "[WARNING] We recommend to not run cozy as root"
    cozy-stack --allow-root -c /cozy/config/cozy.yaml
else 
    su cozy -c "cozy-stack serve -c /cozy/config/cozy.yaml"
fi