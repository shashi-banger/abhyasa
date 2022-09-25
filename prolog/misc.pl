:- use_module(library('clpfd')).
%%:- use_module(library('clp/bounds')).
% Get even number from a input list

even(N) :-  0 is mod(N,2) .

% Using findall
all_even(L1, L2) :- findall(X, (member(X, L1), 0 is X mod 2), L2) .

% using recursion
all_evens_1([], []). 
all_evens_1([H|T], L1) :- 
    integer(H),
    even(H) -> L1=[H|T1],all_evens_1(T,T1) ;
    all_evens_1(T, L1) .

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Map cust function to a list


myadd(A,B,C) :- 
    C #= A+B .

apply_to_list(L1, L2) :- 
maplist(myadd(3), L1, L2) .

apply_sum_1([],[]).
apply_sum_1([H|T], L2):- 
    L2=[C | T1], myadd(3,H,C), apply_sum_1(T,T1) .


% Example usage of floowing
% apply_sum_2(myadd(3),[2,3,4,5],Y).
apply_sum_2(_,[],[]).
apply_sum_2(G, [H|T], L2):- 
    L2=[C | T1], write(G+' '), write(H+ ' '),
    call(G,H,C),
    apply_sum_2(G, T,T1) .


print_members(List) :-
	member(X, List),
	writeln(X),
	fail.
print_members(_).


% Choose three uniq from range L..U
choice(L,U, [A,B,C]) :- 
    Vars=[A,B,C], Vars ins L..U, all_different([A,B,C]), label(Vars).



valuable(gold) .
valuable(silver) :- !.
valuable(bronze).

schedule([foo(2,4),foo(5,6),foo(3,5), foo(3,10), foo(4,5)]).
is_foo_3(foo(X,_)) :- X = 3 .


action(take_next_show, _) . 
action(take_next_event, _) . 


startmode(fixed).
startmode(follow).
startmode(truetime).
startmode(manual).

eventtype(primary).
eventtype(nonprimary).


endmode(duration) .
endmode(manual) .

event(_Eventid, _Start, _End, Smode, Emode, Etype):- startmode(Smode),endmode(Emode),eventtype(Etype), !.
null_event .


check_null_event(E):- 
    E = null_event .


my_cmp(X, L,R) :- 
    atom_length(L,Llen),atom_length(R,Rlen),
    ((Llen < Rlen) -> X = '<' ;
     (Llen > Rlen) -> X = '>' ;
     X = '=').