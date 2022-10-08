# redis-group

The `swipl/redis-group` container acts as a generic Prolog-based Redis
stream consumer group running on Alpine Linux. The main thread runs a
stream listener after setting up the default Redis connection. Base a
derived image on this one and supply the consume listening predicates to
react to stream events using programmable logic.

The Redis group containers require three mandatory environment
variables that specify how to configure the group listener. The consumer
group derives from the environment variable `REDIS_GROUP`. The group
listens to one or more streams identified by the environment variable
`REDIS_KEYS` whose value specifies an atom list of one or more stream
keys. The listener automatically creates the streams if they do not
already exist.

## Redis URL

The environment variable REDIS_URL defines the external Redis server connection. It defaults to `localhost` which never works for containers because the local host does *not* serve Redis.
