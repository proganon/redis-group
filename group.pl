/*  File:    srv/group.pl
    Author:  Roy Ratcliffe
    Created: Oct  2 2022
    Purpose: Connect to Redis Stream Group

Copyright (c) 2022, Roy Ratcliffe, Northumberland, United Kingdom

Permission is hereby granted, free of charge,  to any person obtaining a
copy  of  this  software  and    associated   documentation  files  (the
"Software"), to deal in  the   Software  without  restriction, including
without limitation the rights to  use,   copy,  modify,  merge, publish,
distribute, sublicense, and/or sell  copies  of   the  Software,  and to
permit persons to whom the Software is   furnished  to do so, subject to
the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT  WARRANTY OF ANY KIND, EXPRESS
OR  IMPLIED,  INCLUDING  BUT  NOT   LIMITED    TO   THE   WARRANTIES  OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR   PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS  OR   COPYRIGHT  HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY,  WHETHER   IN  AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM,  OUT  OF   OR  IN  CONNECTION  WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

:- load_files(redis, [if(not_loaded)]).

:- setting(redis_group, atom,
           env('REDIS_GROUP'), 'Redis consumer group to join').
:- setting(redis_consumer, atom,
           env('HOSTNAME'), 'Name of Redis consumer').
:- setting(redis_keys, list(atom),
           env('REDIS_KEYS'), 'List of Redis stream keys to consume').

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

Uses `HOSTNAME` environment variable as the default consumer name
assuming that Docker generates a unique random name for the consumer
container. Falls back to gethostname/1 if the environment variable has
not been set and therefore the `redis_consumer` setting does not exist.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

:- initialization(main, main).

main :-
    setting(redis_group, Group),
    catch(setting(redis_consumer, Consumer),
          error(existence_error(setting, _), _),
          gethostname(Consumer)),
    setting(redis_keys, Keys),
    forall(member(Key, Keys), xgroup_create(Key, Group)),
    xlisten_group(default, Group, Consumer, Keys,
                  [ block(0.1)
                  ]).

xgroup_create(Key, Group) :-
    catch(redis(default, xgroup(create, Key, Group, $, mkstream), status(ok)),
          error(redis_error(busygroup, _), _), true).
