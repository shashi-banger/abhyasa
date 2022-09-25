% Usage: swipl -f -q cli_example.pl misc
:- initialization main.


main :-
  current_prolog_flag(argv, Argv),
  format('Hello World, argv:~w\n', [Argv]),
  consult_all([Argv]),
  print_members([foo, boo, 1,2,3]),
  halt(0).

consult_all([]) .
consult_all([H | T]):-
    consult(H),
    consult_all(T) .