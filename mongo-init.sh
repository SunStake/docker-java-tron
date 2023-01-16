#!/bin/bash

set -e

mongosh -u $MONGO_INITDB_ROOT_USERNAME -p $MONGO_INITDB_ROOT_PASSWORD <<EOF
db = db.getSiblingDB('$DB_NAME')

db.createUser({
  user: '$DB_USER',
  pwd: '$DB_PASSWORD',
  roles: [{ role: 'readWrite', db: '$DB_NAME' }],
});
db.createCollection('block');
db.createCollection('transaction');

EOF
