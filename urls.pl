/*  File:    srv/url.pl
    Author:  Roy Ratcliffe
    Created: Oct  2 2022
    Purpose: Convert URL to Protocol, Host and Port

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

:- module(urls,
          [ url_address/3                       % +URL,?Protocol,-HostPort
          ]).
:- autoload(library(url), [parse_url/2]).

%!  url_address(+URL, ?Protocol, -HostPort) is semidet.
%
%   HostPort for Protocol at URL. The URL must contain a Port number,
%   otherwise fails. For example:
%
%       ?- url_address('tcp://localhost:1234', A, B:C).
%       A = tcp,
%       B = localhost,
%       C = 1234.
%
%   @arg URL is the text to parse as an URL.
%
%   @arg Protocol unifies with the URL's protocol.
%
%   @arg HostPort is a colon-functor compound comprising a Host atom and
%   Port integer.

url_address(URL, Protocol, Host:Port) :-
    parse_url(URL, Attributes),
    memberchk(protocol(Protocol), Attributes),
    memberchk(host(Host), Attributes),
    memberchk(port(Port), Attributes).
