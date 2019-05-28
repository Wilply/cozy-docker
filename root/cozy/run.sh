#!/bin/sh

echo \#\#\# Cozy dockerized by Wilply \#\#\#

[ -z "${UID}" ] && UID=1500
[ -z "${GID}" ] && GID=1500
[ -z "${DOMAIN}" ] && DOMAIN=cozy.test
[ -z "${RUN_AS_ROOT}" ] && RUN_AS_ROOT=0
[ -z "${COZY_ADMIN_PASSWORD}" ] && export COZY_ADMIN_PASSWORD=changeme

if [ ! -e /cozy/cozy-admin-passphrase ]; then
	printf ${COZY_ADMIN_PASSWORD}'\n'${COZY_ADMIN_PASSWORD}'\n' | cozy-stack config password /cozy
fi

if [ ! -e /cozy/config/cozy.yaml ]; then
    echo "[INFO] Using embed cozy config file"
    cp /cozy/cozy.sample.yaml /cozy/config/cozy.yaml
fi

if [ $(cat /etc/passwd | grep -c cozy) != 1 ]; then
    addgroup -g ${GID} cozy
    adduser -h /cozy -G cozy -D -H -u ${UID} cozy
    chown -R cozy:cozy /cozy/
fi

(sleep 10 && echo "[INFO] creating instance for domain \"${DOMAIN}\"" && \
cozy-stack instance add --passphrase changeme --apps store,drive,settings ${DOMAIN}) &

if [ ${RUN_AS_ROOT} = 1 ]; then
    echo "[WARNING] We recommend to not run cozy as root"
    cozy-stack --allow-root -c /cozy/config/cozy.yaml
else 
    su cozy -c "cozy-stack serve -c /cozy/config/cozy.yaml"
fi