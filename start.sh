#!/bin/bash
source .env

# check if MONGO_INITDB_ROOT_PASSWORD in .env is empty or doesnt exist
if [ -z "$MONGO_INITDB_ROOT_PASSWORD" ]; then
    echo "[CREDENTIALS] Unsafe credentials detected. Generating new credentials..."
    
    MONGO_INITDB_ROOT_USERNAME=root
    MONGO_INITDB_ROOT_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13)
    
    DB_USER=tron
    DB_PASSWORD=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 13)
    
    # Credentials:
    echo "MongoDB ROOT credentials: $MONGO_INITDB_ROOT_USERNAME:$MONGO_INITDB_ROOT_PASSWORD"
    echo "MongoDB USER credentials: $DB_USER:$DB_PASSWORD"
    
    echo "Writing credentials to .env file..."
    
    # Emptying .env file before writing new credentials
    :> .env
    
    # Writing credentials to .env file
    echo "MONGO_INITDB_ROOT_USERNAME=$MONGO_INITDB_ROOT_USERNAME" >> .env
    echo "MONGO_INITDB_ROOT_PASSWORD=$MONGO_INITDB_ROOT_PASSWORD" >> .env
    echo "DB_USER=$DB_USER" >> .env
    echo "DB_PASSWORD=$DB_PASSWORD" >> .env
fi

echo "---"
echo "Starting Tron Node..."
echo "[MAINNET]"

# Start Tron Node
# docker compose up -d