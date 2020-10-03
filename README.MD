# Dockerfile for java-tron

This repository hosts custom Dockerfiles for building [java-tron](https://github.com/tronprotocol/java-tron) images that are more container-friendly and works out of the box.

## Docker Hub

Images are built with Docker Hub's automated build service. Available [here](https://hub.docker.com/r/sunstake/java-tron).

## Configuration

Configuration can be done via environment variables. The entry script modifies the config file on the fly before the node is run.

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

### CONFIG_EVENT_PLUGIN_ENABLED

Whether to enable the Kafka [event plugin](https://github.com/tronprotocol/event-plugin).

Options:

- `true`
- `false` (default)

### EVENT_PLUGIN_KAFKA_SERVER

Kafka server address for the event plugin. Mandatory if `CONFIG_EVENT_PLUGIN_ENABLED` is `true`.

### EVENT_PLUGIN_BLOCK_TRIGGER_ENABLED

Whether to enable the `block` trigger for the event plugin.

Options:

- `true`
- `false` (default)

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
