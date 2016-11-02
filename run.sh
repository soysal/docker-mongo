#!/bin/bash

CMD="mongod"

if [ "$MONGO_AUTH" == "yes" ]
then
    CMD="$CMD --auth"
fi


$CMD &

if [ ! -f /data/db/.mongodb_password_set ]; then
	USER=${MONGODB_USER:-"admin"}
	DATABASE=${MONGODB_DATABASE:-"admin"}
	PASS=${MONGODB_PASS:-"admin"}

	RET=1
	while [[ RET -ne 0 ]]; do
		echo "=> Waiting for confirmation of MongoDB service startup"
		sleep 5
		mongo admin --eval "help" >/dev/null 2>&1
		RET=$?
	done

	mongo admin --eval "db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'root',db:'admin'}]});"

	if [ "$DATABASE" != "admin" ]; then
		mongo admin --eval "db.createUser({user: '$USER', pwd: '$PASS', roles:[{role:'dbOwner',db:'$DATABASE'}]});"
	fi

	touch /data/db/.mongodb_password_set
fi
