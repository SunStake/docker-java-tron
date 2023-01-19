#!/bin/bash

set -e

historyTimeStamp=0
if [[ $foo != *[!0-9]* ]];
then
   let historyTimeStamp=$(date +%s)*1000
   let historyTimeStamp=historyTimeStamp-24*3600*10*1000
fi

mongo -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD <<EOF
db = db.getSiblingDB('$DB_NAME')
db.transaction.remove({"timeStamp":{\$lt: ${historyTimeStamp}}})
db.block.remove({"timeStamp":{\$lt: ${historyTimeStamp}}})
db.contractevent.remove({"timeStamp":{\$lt: ${historyTimeStamp}}})
db.contractlog.remove({"timeStamp":{\$lt: ${historyTimeStamp}}})


EOF
