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

redis_xlisten_group :-
    redis_xgroup(Group),
    redis_xlisten_group_consumer(Consumer),
    setting(redis_xgroup_create_keys, Keys),
    setting(redis_xlisten_group_options, Options),
    xlisten_group(default, Group, Consumer, Keys, Options).
