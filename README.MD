# Dockerfile for java-tron

This repository hosts custom Dockerfiles for building [java-tron](https://github.com/tronprotocol/java-tron) images that are more container-friendly and works out of the box.

## Docker Hub

Images are built with Docker Hub's automated build service. Available [here](https://hub.docker.com/r/sunstake/java-tron).

## Data Storage

Blockchain data are stored in `/data`. No volume is mounted by default. Mount a volume to `/data` for data persistence.

For example, you can use an existing `output-directory` on your host system at `/your/output-directory` with:

    $ docker run -v /your/output-directory:/data sunstake/java-tron:4.0.1

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

### VM_MAX_TIME_RATIO

TVM time ratio to avoid timeout. See this [issue](https://github.com/tronprotocol/java-tron/issues/2228). Defaults to `5.0`.

### EVENT_PLUGIN_ENABLED

Whether to enable the Kafka [event plugin](https://github.com/tronprotocol/event-plugin).

Options:

- `true`
- `false` (default)

### EVENT_PLUGIN_KAFKA_SERVER

Kafka server address for the event plugin. Mandatory if `EVENT_PLUGIN_ENABLED` is `true`.

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

### EVENT_PLUGIN_ADDRESS_FILTER

Contract address filter for the event plugin. Multiple addresses are separated by space. By default no filter is applied.

### EVENT_PLUGIN_TOPIC_FILTER

Contract topic filter for the event plugin. Multiple topics are separated by space. By default no filter is applied.
