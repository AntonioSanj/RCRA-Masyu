% usar predicado nodos marcados, predicado es codo
% no puedes tener una posicion a uno de una bola negra q si sea codo
% problem data
#const n=6.
black(0;12;26).
white(10;13;22;23;31;34).

row(0..n-1).
col(0..n-1).

adj( (X,Y), (X,Y + 1)) :- row(X), col(Y), col(Y + 1). % crear adyacencia horizontal
adj( (X,Y), (X + 1,Y)) :- row(X), col(Y), row(X + 1). % crear adyacencia vertical

{edge(X,Y)} :- adj(X,Y). %generar posibles aristas
edge(X,Y) :- edge(X,Y). % en los dos sentidos


