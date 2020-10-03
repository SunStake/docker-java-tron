#!/bin/bash

CONFIG_FILE=/etc/tron/mainnet_config.conf
CONFIG_P2P_PORT=18888
CONFIG_FULL_NODE_PORT=8090
CONFIG_SOLIDITY_NODE_PORT=8091

if [[ -z "${NETWORK}" ]] || [[ "${NETWORK}" == "mainnet" ]]; then
  # Network set to mainnet
  :
elif [[ "${NETWORK}" == "nile" ]]; then
  # Network set to nile
  CONFIG_FILE=/etc/tron/nile_config.conf
  :
else
  echo "Invalid NETWORK: ${NETWORK}. Must be one of: \"mainnet\", \"nile\""
  exit 1
fi

if [[ -n "${P2P_PORT}" ]]; then
  CONFIG_P2P_PORT=${P2P_PORT}
fi

if [[ -n "${FULL_NODE_PORT}" ]]; then
  CONFIG_FULL_NODE_PORT=${FULL_NODE_PORT}
fi

if [[ -n "${SOLIDITY_NODE_PORT}" ]]; then
  CONFIG_SOLIDITY_NODE_PORT=${SOLIDITY_NODE_PORT}
fi

sed -i -e "s/listen.port = .*/listen.port = ${CONFIG_P2P_PORT}/g" ${CONFIG_FILE}
sed -i -e "s/fullNodePort = .*/fullNodePort = ${CONFIG_FULL_NODE_PORT}/g" ${CONFIG_FILE}
sed -i -e "s/solidityPort = .*/solidityPort = ${CONFIG_SOLIDITY_NODE_PORT}/g" ${CONFIG_FILE}

exec java -jar /usr/local/tron/FullNode.jar -c ${CONFIG_FILE} -d /data
