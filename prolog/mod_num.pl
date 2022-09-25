
% Rules to modify a given array so that zeros are removed
% even number are halved and odd numbers are replaced by 
% atom odd

mod_num([],[]) :- ! .
mod_num([0 | T], T1):-  mod_num(T, T1), ! .
mod_num([H | T], [H1 | T1]):- 0 is (H mod 2), H1 is H/2, mod_num(T,T1), ! .
mod_num([H | T], [odd | T1]):- 1 is (H mod 2), mod_num(T,T1).