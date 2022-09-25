
:- use_module(library(date)).

curr_time_str(X) :- get_time(Stamp),format_time(atom(X), '%FT%TZ', Stamp, posix).