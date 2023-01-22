#!/bin/bash

CONFIG_FILE=/etc/tron/mainnet_config.conf
CONFIG_P2P_PORT=18888
CONFIG_FULL_NODE_PORT=8090
CONFIG_SOLIDITY_NODE_PORT=8091
CONFIG_VM_MAX_TIME_RATIO=5.0

CONFIG_EVENT_PLUGIN_ENABLED=false
CONFIG_EVENT_PLUGIN_BACKEND=""
CONFIG_EVENT_PLUGIN_PATH=""
CONFIG_EVENT_PLUGIN_SERVER=""
CONFIG_EVENT_PLUGIN_SERVER_AUTH=""
CONFIG_EVENT_PLUGIN_STARTING_BLOCK=""
CONFIG_BLOCK_TRIGGER_ENABLED=false
CONFIG_TRANSACTION_TRIGGER_ENABLED=false
CONFIG_CONTRACTEVENT_TRIGGER_ENABLED=false
CONFIG_CONTRACTLOG_TRIGGER_ENABLED=false
CONFIG_SOLIDITY_BLOCK_TRIGGER_ENABLED=false
CONFIG_SOLIDITY_EVENT_TRIGGER_ENABLED=false
CONFIG_SOLIDITY_LOG_TRIGGER_ENABLED=false
CONFIG_CONTRACT_ADDRESS_FILTER="\"\""
CONFIG_CONTRACT_TOPIC_FILTER="\"\""
RPC_FULL_NODE=8545
RPC_SOLIDITY_NODE=8555

ES_FLAG=""
WITNESS_FLAG=""

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

if [[ -z "${WITNESS_MODE}" ]] || [[ "${WITNESS_MODE}" == "false" ]]; then
  # Witness mode disabled
  :
elif [[ "${WITNESS_MODE}" == "true" ]]; then
  # Witness mode enabled
  WITNESS_FLAG="--witness"
  :
else
  echo "Invalid WITNESS_MODE: ${WITNESS_MODE}. Must be one of: \"true\", \"false\""
  exit 1
fi

if [[ -z "${EVENT_PLUGIN_ENABLED}" ]] || [[ "${EVENT_PLUGIN_ENABLED}" == "false" ]]; then
  # Event plugin disabled
  :
elif [[ "${EVENT_PLUGIN_ENABLED}" == "true" ]]; then
  # Event plugin enabled
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

if [[ -n "${RPC_FULL_NODE}" ]]; then
  RPC_FULL_NODE=${RPC_FULL_NODE}
fi

if [[ -n "${RPC_SOLIDITY_NODE}" ]]; then
  RPC_SOLIDITY_NODE=${RPC_SOLIDITY_NODE}
fi

if [[ -n "${SOLIDITY_NODE_PORT}" ]]; then
  CONFIG_SOLIDITY_NODE_PORT=${SOLIDITY_NODE_PORT}
fi

if [[ -n "${VM_MAX_TIME_RATIO}" ]]; then
  CONFIG_VM_MAX_TIME_RATIO=${VM_MAX_TIME_RATIO}
fi

# Event plugin related configs
if [[ "${CONFIG_EVENT_PLUGIN_ENABLED}" == "true" ]]; then
  ES_FLAG="--es"

  if [[ -z "${EVENT_PLUGIN_STARTING_BLOCK}" ]]; then
    CONFIG_EVENT_PLUGIN_STARTING_BLOCK=0
  else
    CONFIG_EVENT_PLUGIN_STARTING_BLOCK=${EVENT_PLUGIN_STARTING_BLOCK}
  fi

  if [[ -z "${EVENT_PLUGIN_BACKEND}" ]]; then
    echo "EVENT_PLUGIN_BACKEND must be specified when event plugin is enabled"
    exit 1
  fi

  if [[ "${EVENT_PLUGIN_BACKEND}" == "mongodb" ]]; then

    if [[ -z "${EVENT_PLUGIN_MONGO_SERVER}" ]]; then
      echo "CONFIG_EVENT_PLUGIN_MONGO_SERVER must be specified when [mongo] event plugin is enabled"
      exit 1
    fi

    CONFIG_EVENT_PLUGIN_PATH='\/usr\/local\/tron\/plugins\/plugin-mongodb-1.0.0.zip'
    CONFIG_EVENT_PLUGIN_SERVER=${EVENT_PLUGIN_MONGO_SERVER}
    CONFIG_EVENT_PLUGIN_SERVER_AUTH="eventlog|${EVENT_PLUGIN_MONGO_DB_USERNAME}|${EVENT_PLUGIN_MONGO_DB_PASSWORD}"

  elif [[ "${EVENT_PLUGIN_BACKEND}" == "kafka" ]]; then

    if [[ -z "${EVENT_PLUGIN_KAFKA_SERVER}" ]]; then
      echo "EVENT_PLUGIN_KAFKA_SERVER must be specified when [kafka] event plugin is enabled"
      exit 1
    fi

    CONFIG_EVENT_PLUGIN_PATH='\/usr\/local\/tron\/plugins\/plugin-kafka-1.0.0.zip'
    CONFIG_EVENT_PLUGIN_SERVER=${EVENT_PLUGIN_KAFKA_SERVER}
  else
    echo "Invalid EVENT_PLUGIN_BACKEND: ${EVENT_PLUGIN_BACKEND}. Must be one of: \"mongodb\", \"kafka\""
    exit 1
  fi


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

  if [[ -z "${EVENT_PLUGIN_SOLIDITY_BLOCK_TRIGGER_ENABLED}" ]] || [[ "${EVENT_PLUGIN_SOLIDITY_BLOCK_TRIGGER_ENABLED}" == "false" ]]; then
    # Solidity block trigger set to false
    :
  elif [[ "${EVENT_PLUGIN_SOLIDITY_BLOCK_TRIGGER_ENABLED}" == "true" ]]; then
    # Solidity block trigger set to true
    CONFIG_SOLIDITY_BLOCK_TRIGGER_ENABLED=true
    :
  else
    echo "Invalid EVENT_PLUGIN_SOLIDITY_BLOCK_TRIGGER_ENABLED: ${EVENT_PLUGIN_SOLIDITY_BLOCK_TRIGGER_ENABLED}. Must be one of: \"true\", \"false\""
    exit 1
  fi

  if [[ -z "${EVENT_PLUGIN_SOLIDITY_EVENT_TRIGGER_ENABLED}" ]] || [[ "${EVENT_PLUGIN_SOLIDITY_EVENT_TRIGGER_ENABLED}" == "false" ]]; then
    # Solidity event trigger set to false
    :
  elif [[ "${EVENT_PLUGIN_SOLIDITY_EVENT_TRIGGER_ENABLED}" == "true" ]]; then
    # Solidity event trigger set to true
    CONFIG_SOLIDITY_EVENT_TRIGGER_ENABLED=true
    :
  else
    echo "Invalid EVENT_PLUGIN_SOLIDITY_EVENT_TRIGGER_ENABLED: ${EVENT_PLUGIN_SOLIDITY_EVENT_TRIGGER_ENABLED}. Must be one of: \"true\", \"false\""
    exit 1
  fi

  if [[ -z "${EVENT_PLUGIN_SOLIDITY_LOG_TRIGGER_ENABLED}" ]] || [[ "${EVENT_PLUGIN_SOLIDITY_LOG_TRIGGER_ENABLED}" == "false" ]]; then
    # Solidity log trigger set to false
    :
  elif [[ "${EVENT_PLUGIN_SOLIDITY_LOG_TRIGGER_ENABLED}" == "true" ]]; then
    # Solidity log trigger set to true
    CONFIG_SOLIDITY_LOG_TRIGGER_ENABLED=true
    :
  else
    echo "Invalid EVENT_PLUGIN_SOLIDITY_LOG_TRIGGER_ENABLED: ${EVENT_PLUGIN_SOLIDITY_LOG_TRIGGER_ENABLED}. Must be one of: \"true\", \"false\""
    exit 1
  fi

  if [[ -n "${EVENT_PLUGIN_ADDRESS_FILTER}" ]]; then
    CONFIG_CONTRACT_ADDRESS_FILTER=""

    IFS="," read -ra FILTER_ADDRESSES <<< ${EVENT_PLUGIN_ADDRESS_FILTER}
    let "LAST_INDEX = ${#FILTER_ADDRESSES[@]} - 1"
    for ind in "${!FILTER_ADDRESSES[@]}"; do
      if [[ "$ind" == "${LAST_INDEX}" ]]; then
        CONFIG_CONTRACT_ADDRESS_FILTER="${CONFIG_CONTRACT_ADDRESS_FILTER}\"${FILTER_ADDRESSES[$ind]}\""
      else
        CONFIG_CONTRACT_ADDRESS_FILTER="${CONFIG_CONTRACT_ADDRESS_FILTER}\"${FILTER_ADDRESSES[$ind]}\",\n      "
      fi
    done
  fi

  if [[ -n "${EVENT_PLUGIN_TOPIC_FILTER}" ]]; then
    CONFIG_CONTRACT_TOPIC_FILTER=""

    IFS="," read -ra FILTER_TOPICS <<< ${EVENT_PLUGIN_TOPIC_FILTER}
    let "LAST_INDEX = ${#FILTER_TOPICS[@]} - 1"
    for ind in "${!FILTER_TOPICS[@]}"; do
      if [[ "$ind" == "${LAST_INDEX}" ]]; then
        CONFIG_CONTRACT_TOPIC_FILTER="${CONFIG_CONTRACT_TOPIC_FILTER}\"${FILTER_TOPICS[$ind]}\""
      else
        CONFIG_CONTRACT_TOPIC_FILTER="${CONFIG_CONTRACT_TOPIC_FILTER}\"${FILTER_TOPICS[$ind]}\",\n      "
      fi
    done
  fi
fi

sed -i -e "s/listen.port = .*/listen.port = ${CONFIG_P2P_PORT}/g" ${CONFIG_FILE}
sed -i -e "s/fullNodePort = .*/fullNodePort = ${CONFIG_FULL_NODE_PORT}/g" ${CONFIG_FILE}
sed -i -e "s/solidityPort = .*/solidityPort = ${CONFIG_SOLIDITY_NODE_PORT}/g" ${CONFIG_FILE}
sed -i -e "s/{VM_MAX_TIME_RATIO_PLACEHOLDER}/${CONFIG_VM_MAX_TIME_RATIO}/g" ${CONFIG_FILE}

sed -i -e "s/{PLUGIN_PATH_PLACEHOLDER}/${CONFIG_EVENT_PLUGIN_PATH}/g" ${CONFIG_FILE}
sed -i -e "s/{PLUGIN_SERVER_PLACEHOLDER}/${CONFIG_EVENT_PLUGIN_SERVER}/g" ${CONFIG_FILE}
sed -i -e "s/{PLUGIN_SERVER_AUTH_PLACEHOLDER}/${CONFIG_EVENT_PLUGIN_SERVER_AUTH}/g" ${CONFIG_FILE}
sed -i -e "s/{PLUGIN_STARTING_BLOCK_PLACEHOLDER}/${CONFIG_EVENT_PLUGIN_STARTING_BLOCK}/g" ${CONFIG_FILE}

sed -i -e "s/{BLOCK_TRIGGER_PLACEHOLDER}/${CONFIG_BLOCK_TRIGGER_ENABLED}/g" ${CONFIG_FILE}
sed -i -e "s/{TRANSACTION_TRIGGER_PLACEHOLDER}/${CONFIG_TRANSACTION_TRIGGER_ENABLED}/g" ${CONFIG_FILE}
sed -i -e "s/{CONTRACTEVENT_TRIGGER_PLACEHOLDER}/${CONFIG_CONTRACTEVENT_TRIGGER_ENABLED}/g" ${CONFIG_FILE}
sed -i -e "s/{CONTRACTLOG_TRIGGER_PLACEHOLDER}/${CONFIG_CONTRACTLOG_TRIGGER_ENABLED}/g" ${CONFIG_FILE}
sed -i -e "s/{SOLIDITY_BLOCK_TRIGGER_PLACEHOLDER}/${CONFIG_SOLIDITY_BLOCK_TRIGGER_ENABLED}/g" ${CONFIG_FILE}
sed -i -e "s/{SOLIDITY_EVENT_TRIGGER_PLACEHOLDER}/${CONFIG_SOLIDITY_EVENT_TRIGGER_ENABLED}/g" ${CONFIG_FILE}
sed -i -e "s/{SOLIDITY_LOG_TRIGGER_PLACEHOLDER}/${CONFIG_SOLIDITY_LOG_TRIGGER_ENABLED}/g" ${CONFIG_FILE}
sed -i -e "s/{CONTRACT_ADDRESS_FILTER_PLACEHOLDER}/${CONFIG_CONTRACT_ADDRESS_FILTER}/g" ${CONFIG_FILE}
sed -i -e "s/{CONTRACT_TOPIC_FILTER_PLACEHOLDER}/${CONFIG_CONTRACT_TOPIC_FILTER}/g" ${CONFIG_FILE}
sed -i -e "s/{RPC_FULL_NODE}/${RPC_FULL_NODE}/g" ${CONFIG_FILE}
sed -i -e "s/{RPC_SOLIDITY_NODE}/${RPC_SOLIDITY_NODE}/g" ${CONFIG_FILE}

COMMAND="./bin/FullNode -c ${CONFIG_FILE} -d /data ${ES_FLAG} ${WITNESS_FLAG}" "$@"


echo "Sleeping 10s to wait for mongo to start up"
sleep 10

echo ${COMMAND}
exec ${COMMAND}
