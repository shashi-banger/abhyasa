%   A teacher wishes to seat 16 quarrelsome children
%   in a 4x4 array of chairs
%   Some of the children don't get along
%   The problem is to seat the children so no student
%   is seated adjacent (4 way adjacent) to a child
%   they quarrel with
%
%  The children are numbered 1 thru 16
%  1..8 are girls, 9..16 are boys
%
%


:- use_module(library(clpfd)).


compatible(Student, Neighbor) :- 
    Student #=3 #==> Neighbor #< 9, %#3 doesn't want to sit next to any boy
    Student #=5 #==> Neighbor #< 9, % #5 behaves same as #3
    Student #=2 #==> Neighbor #\=3,
    Student #=10 #==> Neighbor #> 8. %#10 does not like girls

constrain_up(1, _ , _ , _).
constrain_up(R, C, S, Board) :-
    R > 1,
    NR is R-1,
    member(seat(NR, C, Neighbor), Board),
    compatible(S, Neighbor) .

constrain_down(4, _ , _ , _).
constrain_down(R, C, S, Board) :-
    R < 4,
    NR is R+1,
    member(seat(NR, C, Neighbor), Board),
    compatible(S, Neighbor) .

constrain_left(_, 1 , _ , _).
constrain_left(R, C, S, Board) :-
    C > 1,
    NC is C-1,
    member(seat(R, NC, Neighbor), Board),
    compatible(S, Neighbor) .


constrain_right(_, 4 , _ , _).
constrain_right(R, C, S, Board) :-
    C < 4,
    NC is C+1,
    member(seat(R, NC, Neighbor), Board),
    compatible(S, Neighbor) .

constrain_pupil(Board, seat(R,C,S)) :-
    constrain_up(R, C, S, Board),
    constrain_down(R, C, S, Board),
    constrain_left(R, C, S, Board),
    constrain_right(R, C, S, Board).


make_seat(R , C , seat(R , C , Student)) :-
	Student in 1..16.

seat_student(seat(_R, _C, S) , S).

make_board(Board) :-
	findall(S ,
	     (   member(R , [1,2,3,4]) ,
	         member(C , [1,2,3,4]) ,
	         make_seat(R , C , S)) ,
	      Board),
	maplist(seat_student , Board , Raw),
	all_distinct(Raw).

write_board(Board) :-
	member(R , [1,2,3,4]),
	nl,
	member(C , [1,2,3,4]),
	member(seat(R, C, S), Board),
	write(S), write(' '),
	fail.
write_board(_) :- nl.

assign_all_pupils :-
	make_board(Board),
	maplist(constrain_pupil(Board) , Board),
	maplist(seat_student , Board , Raw),
	labeling([], Raw),
	write_board(Board).