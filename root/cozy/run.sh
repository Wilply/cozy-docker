#!/bin/sh

[ -z "${UID}" ] && UID=1500
[ -z "${GID}" ] && GID=1500
[ -z "${RUN_AS_ROOT}" ] && RUN_AS_ROOT=0
#[ -z "${COZY_ADMIN_PASS}" ] &&  COZY_ADMIN_PASS=changeme

#if [ ! -e /cozy/cozy-admin-passphrase ]; then
#	printf ${COZY_ADMIN_PASS}'\n'${COZY_ADMIN_PASS}'\n' | cozy-stack config password /cozy
#fi

if [ $(cat /etc/passwd | grep -c cozy) != 1 ]; then
    addgroup -g ${GID} cozy #busybox
#    groupadd -g ${GID} cozy
    adduser -h /cozy -G cozy -D -H -u ${UID} cozy #busybox
#    useradd -d /cozy -g cozy -M -u ${UID} cozy
    chown -R cozy:cozy /cozy/
fi

if [ ${RUN_AS_ROOT} = 1 ]; then
    echo "[WARNING] We recommend to not run cozy as root"
    cozy-stack --allow-root -c /cozy/config/cozy.yaml
else 
    su cozy -c "cozy-stack serve -c /cozy/config/cozy.yaml"
fi