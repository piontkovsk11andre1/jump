#!/bin/sh

# PostgreSQL primary server connection:
consul kv put database/postgres/primary/user $POSTGRES_USER
consul kv put database/postgres/primary/password $POSTGRES_PASSWORD
consul kv put database/postgres/primary/db $POSTGRES_DB

# PostgreSQL secondary server connection:
consul kv put database/postgres/standby/user $POSTGRES_USER
consul kv put database/postgres/standby/password $POSTGRES_PASSWORD
consul kv put database/postgres/standby/db $POSTGRES_DB

# Clickhouse server connection:
consul kv put database/clickhouse/user $CLICKHOUSE_USER
consul kv put database/clickhouse/password $CLICKHOUSE_PASSWORD
consul kv put database/clickhouse/db $CLICKHOUSE_DATABASE

# MongoDB server connection:
consul kv put database/mongo/user $MONGO_INITDB_ROOT_USERNAME
consul kv put database/mongo/password $MONGO_INITDB_ROOT_PASSWORD

# Redis server connection:
consul kv put database/redis/user ""
consul kv put database/redis/password ""

# Vault server connection:
consul kv put database/vault/key ""

# RabbitMQ server connection:
consul kv put database/rabbitmq/user $RABBITMQ_DEFAULT_USER
consul kv put database/rabbitmq/password $RABBITMQ_DEFAULT_PASS

# Opensearch node connection:
consul kv put index/opensearch/node1/user $OPENSEARCH_DEFAULT_USER
consul kv put index/opensearch/node1/password $OPENSEARCH_DEFAULT_PASS