:- setting(redis_xlisten_group_consumer, atom, env('HOSTNAME', ''),
           'Name of Redis stream group consumer').
:- setting(redis_xlisten_group_options, list(any),
           env('REDIS_XLISTEN_GROUP_OPTIONS', []),
           'Options for Redis stream group listen').

redis_xlisten_group_consumer(Consumer) :-
    setting(redis_xlisten_group_consumer, Consumer),
    Consumer \== '',
    !.
redis_xlisten_group_consumer(Consumer) :- gethostname(Consumer).

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Become a stream group consumer by listening on one or more stream keys.
Use the host name as the consumer.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

redis_xlisten_group :-
    setting(redis_alias, Redis),
    redis_xgroup(Group),
    redis_xlisten_group_consumer(Consumer),
    setting(redis_xgroup_create_keys, Keys),
    setting(redis_xlisten_group_options, Options),
    xlisten_group(Redis, Group, Consumer, Keys, Options).
