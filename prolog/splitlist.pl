
% splitlist(N, L, X, Y)
% List L will be split such that X = {Elements in L less than N}
% and Y = {Elements in L greater than or equal to N}.

splitlist(_, [], [], []) .
splitlist(N, [H | T], [H1 | T1], L1) :- (H < N), H1=H, splitlist(N, T, T1, L1), ! .
splitlist(N, [H | T], L1, [H1 | T1]) :-  H1=H, splitlist(N, T, L1, T1), ! .