#!/bin/bash

CONFIG_FILE=/etc/tron/mainnet_config.conf
CONFIG_P2P_PORT=18888
CONFIG_FULL_NODE_PORT=8090
CONFIG_SOLIDITY_NODE_PORT=8091

CONFIG_EVENT_PLUGIN_ENABLED=false
CONFIG_EVENT_PLUGIN_PATH=""
CONFIG_EVENT_PLUGIN_KAFKA_SERVER=""
CONFIG_BLOCK_TRIGGER_ENABLED=false
CONFIG_TRANSACTION_TRIGGER_ENABLED=false
CONFIG_CONTRACTEVENT_TRIGGER_ENABLED=false
CONFIG_CONTRACTLOG_TRIGGER_ENABLED=false

ES_FLAG=""

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

if [[ -z "${EVENT_PLUGIN_ENABLED}" ]] || [[ "${EVENT_PLUGIN_ENABLED}" == "false" ]]; then
  # Event plugin disabled
  :
elif [[ "${EVENT_PLUGIN_ENABLED}" == "true" ]]; then
  # Network set to nile
  CONFIG_EVENT_PLUGIN_ENABLED=true
  :
else
  echo "Invalid EVENT_PLUGIN_ENABLED: ${EVENT_PLUGIN_ENABLED}. Must be one of: \"true\", \"false\""
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

# Event plugin related configs
if [[ "${CONFIG_EVENT_PLUGIN_ENABLED}" == "true" ]]; then
  if [[ -z "${EVENT_PLUGIN_KAFKA_SERVER}" ]]; then
    echo "EVENT_PLUGIN_KAFKA_SERVER must be specified when event plugin is enabled"
    exit 1
  fi

  ES_FLAG="--es"

  CONFIG_EVENT_PLUGIN_PATH='\/usr\/local\/tron\/plugins\/plugin-kafka-1.0.0.zip'
  CONFIG_EVENT_PLUGIN_KAFKA_SERVER=${EVENT_PLUGIN_KAFKA_SERVER}

  if [[ -z "${EVENT_PLUGIN_BLOCK_TRIGGER_ENABLED}" ]] || [[ "${EVENT_PLUGIN_BLOCK_TRIGGER_ENABLED}" == "false" ]]; then
    # Block trigger set to false
    :
  elif [[ "${EVENT_PLUGIN_BLOCK_TRIGGER_ENABLED}" == "true" ]]; then
    # Block trigger set to true
    CONFIG_BLOCK_TRIGGER_ENABLED=true
    :
  else
    echo "Invalid EVENT_PLUGIN_BLOCK_TRIGGER_ENABLED: ${EVENT_PLUGIN_BLOCK_TRIGGER_ENABLED}. Must be one of: \"true\", \"false\""
    exit 1
  fi

  if [[ -z "${EVENT_PLUGIN_TRANSACTION_TRIGGER_ENABLED}" ]] || [[ "${EVENT_PLUGIN_TRANSACTION_TRIGGER_ENABLED}" == "false" ]]; then
    # Transaction trigger set to false
    :
  elif [[ "${EVENT_PLUGIN_TRANSACTION_TRIGGER_ENABLED}" == "true" ]]; then
    # Transaction trigger set to true
    CONFIG_TRANSACTION_TRIGGER_ENABLED=true
    :
  else
    echo "Invalid EVENT_PLUGIN_TRANSACTION_TRIGGER_ENABLED: ${EVENT_PLUGIN_TRANSACTION_TRIGGER_ENABLED}. Must be one of: \"true\", \"false\""
    exit 1
  fi

  if [[ -z "${EVENT_PLUGIN_CONTRACTEVENT_TRIGGER_ENABLED}" ]] || [[ "${EVENT_PLUGIN_CONTRACTEVENT_TRIGGER_ENABLED}" == "false" ]]; then
    # Contractevent trigger set to false
    :
  elif [[ "${EVENT_PLUGIN_CONTRACTEVENT_TRIGGER_ENABLED}" == "true" ]]; then
    # Contractevent trigger set to true
    CONFIG_CONTRACTEVENT_TRIGGER_ENABLED=true
    :
  else
    echo "Invalid EVENT_PLUGIN_CONTRACTEVENT_TRIGGER_ENABLED: ${EVENT_PLUGIN_CONTRACTEVENT_TRIGGER_ENABLED}. Must be one of: \"true\", \"false\""
    exit 1
  fi

  if [[ -z "${EVENT_PLUGIN_CONTRACTLOG_TRIGGER_ENABLED}" ]] || [[ "${EVENT_PLUGIN_CONTRACTLOG_TRIGGER_ENABLED}" == "false" ]]; then
    # Contractlog trigger set to false
    :
  elif [[ "${EVENT_PLUGIN_CONTRACTLOG_TRIGGER_ENABLED}" == "true" ]]; then
    # Contractlog trigger set to true
    CONFIG_CONTRACTLOG_TRIGGER_ENABLED=true
    :
  else
    echo "Invalid EVENT_PLUGIN_CONTRACTLOG_TRIGGER_ENABLED: ${EVENT_PLUGIN_CONTRACTLOG_TRIGGER_ENABLED}. Must be one of: \"true\", \"false\""
    exit 1
  fi
fi

sed -i -e "s/listen.port = .*/listen.port = ${CONFIG_P2P_PORT}/g" ${CONFIG_FILE}
sed -i -e "s/fullNodePort = .*/fullNodePort = ${CONFIG_FULL_NODE_PORT}/g" ${CONFIG_FILE}
sed -i -e "s/solidityPort = .*/solidityPort = ${CONFIG_SOLIDITY_NODE_PORT}/g" ${CONFIG_FILE}

sed -i -e "s/PLUGIN_PATH_PLACEHOLDER/${CONFIG_EVENT_PLUGIN_PATH}/g" ${CONFIG_FILE}
sed -i -e "s/KAFKA_SERVER_PLACEHOLDER/${CONFIG_EVENT_PLUGIN_KAFKA_SERVER}/g" ${CONFIG_FILE}
sed -i -e "s/BLOCK_TRIGGER_PLACEHOLDER/${CONFIG_BLOCK_TRIGGER_ENABLED}/g" ${CONFIG_FILE}
sed -i -e "s/TRANSACTION_TRIGGER_PLACEHOLDER/${CONFIG_TRANSACTION_TRIGGER_ENABLED}/g" ${CONFIG_FILE}
sed -i -e "s/CONTRACTEVENT_TRIGGER_PLACEHOLDER/${CONFIG_CONTRACTEVENT_TRIGGER_ENABLED}/g" ${CONFIG_FILE}
sed -i -e "s/CONTRACTLOG_TRIGGER_PLACEHOLDER/${CONFIG_CONTRACTLOG_TRIGGER_ENABLED}/g" ${CONFIG_FILE}

COMMAND="java -jar /usr/local/tron/FullNode.jar -c ${CONFIG_FILE} -d /data ${ES_FLAG}"

echo ${COMMAND}
exec ${COMMAND}
