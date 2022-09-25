
stock(amg, "Amagi", 200.0).
stock(tat, "tata", 100.0).
stock(rel, "Reliance", 500.50).

price(S,P):- stock(S, _, P).
name(S,N):- stock(S,N,_).
