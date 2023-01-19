#!/bin/bash

set -e

mongo -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD <<EOF
db = db.getSiblingDB('$DB_NAME')

db.createUser({
  user: '$DB_USER',
  pwd: '$DB_PASSWORD',
  roles: [{ role: 'readWrite', db: '$DB_NAME' }],
});
db.createCollection('block');
db.createCollection('transaction');
db.transaction.ensureIndex({fromAddress:-1})
db.transaction.ensureIndex({contractType:-1})
db.transaction.ensureIndex({toAddress:-1})
db.transaction.ensureIndex({timeStamp:-1})
db.transaction.ensureIndex({transactionId:-1})
db.transaction.ensureIndex({blockHash:-1})
db.transaction.ensureIndex({blockNumber:-1})
db.transaction.ensureIndex({contractAddress:-1})
db.transaction.ensureIndex({assetName:-1})
db.transaction.ensureIndex({latestSolidifiedBlockNumber:-1})
db.contractevent.ensureIndex({eventSignature:-1})
db.contractevent.ensureIndex({transactionId:-1})
db.contractevent.ensureIndex({contractAddress:-1})
db.contractevent.ensureIndex({blockNumber:-1})
db.contractevent.ensureIndex({timeStamp:-1})
db.contractevent.ensureIndex({eventName:-1})
db.contractevent.ensureIndex({latestSolidifiedBlockNumber:-1})
db.contractevent.ensureIndex({removed:-1})
db.contractevent.ensureIndex({uniqueId:-1})
db.contractevent.ensureIndex({contractAddress:-1, eventName:-1, blockNumber:-1})
db.block.ensureIndex({blockNumber:-1})
db.block.ensureIndex({blockHash:-1})
db.block.ensureIndex({timeStamp:-1})
db.block.ensureIndex({latestSolidifiedBlockNumber:-1})
db.contractlog.ensureIndex({transactionId:-1})
db.contractlog.ensureIndex({contractAddress:-1})
db.contractlog.ensureIndex({blockNumber:-1})
db.contractlog.ensureIndex({removed:-1})
db.contractlog.ensureIndex({latestSolidifiedBlockNumber:-1})
db.contractlog.ensureIndex({timeStamp:-1})

EOF
