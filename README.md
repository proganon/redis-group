# Redis Stream Group Consumer Using Programmable Logic

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

Launch such a "Redis Group" using:
```bash
docker run --rm -it -e REDIS_GROUP=mygroup -e REDIS_KEYS="[mykey1, mykey2, mykey3]" $(docker build -q .)
```
This assumes that a Redis server runs on Docker already. Docker can launch a local Redis server, with a useful web interface on port 8001, using:
```bash
docker run -d -p 6379:6379 -p 8001:8001 redis/redis-stack
```

## Redis URL

The environment variable `REDIS_URL` defines the Redis server connection to use.
It defaults to `host.docker.internal` which works for containers running on a
host that exposes a Redis server on the default port, 6379.
