:- use_module(library('clp/bounds')).

choice(L,U, [A,B,C]) :- Vars = [A,B,C], Vars in L..U, all_different([A,B,C]), label(Vars).