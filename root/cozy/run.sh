#!/bin/sh

echo \#\#\# Cozy dockerized by Wilply \#\#\#

[ -z "${UID}" ] && UID=1500
[ -z "${GID}" ] && GID=1500
[ -z "${RUN_AS_ROOT}" ] && RUN_AS_ROOT=0
[ -z "${COZY_ADMIN_PASS}" ] && COZY_ADMIN_PASS=changeme

if [ ! -e /cozy/cozy-admin-passphrase ]; then
	printf ${COZY_ADMIN_PASS}'\n'${COZY_ADMIN_PASS}'\n' | cozy-stack config password /cozy
fi

if [ ! -e /cozy/config/cozy.yaml ]; then
    echo "[INFO] Using embed cozy config file"
    cp /cozy/cozy.yaml /cozy/config/cozy.yaml
fi

if [ $(cat /etc/passwd | grep -c cozy) != 1 ]; then
    addgroup -g ${GID} cozy
#    groupadd -g ${GID} cozy #debian slim
    adduser -h /cozy -G cozy -D -H -u ${UID} cozy
#    useradd -d /cozy -g cozy -M -u ${UID} cozy #debian slim
    chown -R cozy:cozy /cozy/
fi

if [ ${RUN_AS_ROOT} = 1 ]; then
    echo "[WARNING] We recommend to not run cozy as root"
    cozy-stack --allow-root -c /cozy/config/cozy.yaml
else 
    su cozy -c "cozy-stack serve -c /cozy/config/cozy.yaml"
fi