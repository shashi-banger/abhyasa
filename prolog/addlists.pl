
addlists([], [], []) .

addlists([HA|TA], [HB|TB], [HC|TC]) :-
    HC #= HA+HB,
    addlists(TA,TB,TC) .

findall(Template, Goal, Bag)
