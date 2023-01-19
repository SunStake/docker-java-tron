## This is not production ready code and should primarily be used for reference.

# Dockerfile for java-tron

This repository hosts custom Dockerfiles for building [java-tron](https://github.com/tronprotocol/java-tron) images that are more container-friendly and works out of the box.

## Fork Notice

This repository has been forked from [SunStake/docker-java-tron](https://github.com/SunStake/docker-java-tron), in order update and extend a bit. 

## Data Storage

Blockchain data is stored in `./data/node`. 

## Configuration

Configuration can be done via environment variables. The entry script modifies the config file on the fly before the node is run.

Most of configuration variables are defined in docker-compose file, secrets are defined in `.env` file, which is created automatically if it doesn't exist by launching `start.sh`.

## Logs

By default node dumps logs into `logs/tron.log`
which we can access using `docker exec -it tron-node tail -f logs/tron.log`

### NETWORK

The Tron network to connect to.

Options:

- `mainnet` (default)
- `nile`

### P2P_PORT

The port on which the node listens on for P2P networking. Defaults to `18888`.

### FULL_NODE_PORT

The port on which the node serves full node HTTP API. Defaults to `8090`.

### SOLIDITY_NODE_PORT

The port on which the node serves solidity node HTTP API. Defaults to `8091`.

### VM_MAX_TIME_RATIO

TVM time ratio to avoid timeout. See this [issue](https://github.com/tronprotocol/java-tron/issues/2228). Defaults to `5.0`.

### WITNESS_MODE

> **NOTE**
>
> This option is only supported on version `4.1.1` or higher.

Whether to enable witness mode (block producer), useful for running a local test network.

Options:

- `true`
- `false` (default)

### EVENT_PLUGIN_ENABLED

Whether to enable the [event plugin](https://github.com/tronprotocol/event-plugin).

Options:

- `true`
- `false` (default)


### EVENT_PLUGIN_BACKEND

Storage backend to use with the [event plugin](https://github.com/tronprotocol/event-plugin).

Options:

- `mongodb`
- `kafka`

### EVENT_PLUGIN_MONGO_SERVER

MongoDB server address for the event plugin. Mandatory if `EVENT_PLUGIN_ENABLED` is `true` and `EVENT_PLUGIN_BACKEND` is `mongodb`.

### EVENT_PLUGIN_KAFKA_SERVER

Kafka server address for the event plugin. Mandatory if `EVENT_PLUGIN_ENABLED` is `true` and `EVENT_PLUGIN_BACKEND` is `kafka`.

### EVENT_PLUGIN_BLOCK_TRIGGER_ENABLED

Whether to enable the `block` trigger for the event plugin.

Options:

- `true`
- `false` (default)

### EVENT_PLUGIN_STARTING_BLOCK

Starting block for the event plugin filter

Options: 
- `Integer`
- `0` (Default)

### EVENT_PLUGIN_TRANSACTION_TRIGGER_ENABLED

Whether to enable the `transaction` trigger for the event plugin.

Options:

- `true`
- `false` (default)

### EVENT_PLUGIN_CONTRACTEVENT_TRIGGER_ENABLED

Whether to enable the `contractevent` trigger for the event plugin.

Options:

- `true`
- `false` (default)

### EVENT_PLUGIN_CONTRACTLOG_TRIGGER_ENABLED

Whether to enable the `contractlog` trigger for the event plugin.

Options:

- `true`
- `false` (default)

### EVENT_PLUGIN_SOLIDITY_BLOCK_TRIGGER_ENABLED

Whether to enable the `solidity` trigger for the event plugin.

Options:

- `true`
- `false` (default)

### EVENT_PLUGIN_SOLIDITY_EVENT_TRIGGER_ENABLED

Whether to enable the `solidityevent` trigger for the event plugin.

Options:

- `true`
- `false` (default)

### EVENT_PLUGIN_SOLIDITY_LOG_TRIGGER_ENABLED

Whether to enable the `soliditylog` trigger for the event plugin.

Options:

- `true`
- `false` (default)

### EVENT_PLUGIN_ADDRESS_FILTER

Contract address filter for the event plugin. Multiple addresses are separated by space. By default no filter is applied.

### EVENT_PLUGIN_TOPIC_FILTER

Contract topic filter for the event plugin. Multiple topics are separated by space. By default no filter is applied.
