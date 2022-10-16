:- setting(redis_xgroup, atom,
           env('REDIS_XGROUP', ''),
           'Name of Redis stream consumer group').
:- setting(redis_xgroup_create_keys, list(atom),
           env('REDIS_XGROUP_CREATE_KEYS', []),
           'List of Redis stream keys to create for group').
:- setting(redis_xgroup_create_options, list(atom),
           env('REDIS_XGROUP_CREATE_OPTIONS', []),
           'Options for Redis stream consumer group creation').

redis_xgroup(Group) :- setting(redis_xgroup, Group), Group \== ''.

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

See https://redis.io/commands/xgroup-create/ for details.

Create each key-group pair. Make the stream if necessary. Start at some
entry if specified. The create options specify any additional options.
Creating a stream group can fail if the group already exists.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

redis_xgroup_create :-
    redis_xgroup(Group),
    setting(redis_xgroup_create_keys, Keys),
    forall(member(Key, Keys), redis_xgroup_create(Group, Key)).

redis_xgroup_create(Group, Key) :-
    setting(redis_alias, Redis),
    setting(redis_xgroup_create_options, Options),
    Command =.. [xgroup, create, Key, Group|Options],
    catch(redis(Redis, Command, status(ok)),
          error(redis_error(busygroup, _), _), true).
