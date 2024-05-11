% usar predicado nodos marcados, predicado es codo
% no puedes tener una posicion a uno de una bola negra q si sea codo

% python encode.py examples/masyu02.txt masyu02.lp

% problem data
#const n=4.
black(0;5;10;15).

row(0..n-1).
col(0..n-1).

% traduccion blancos y negros a coordenadas
blackCoor((Y,X\n)) :- black(X), X/n=Y.
whiteCoor((Y,X\n)) :- white(X), X/n=Y.

% crear adyacencia horizontal, no se crea si no existe una columna a la derecha
adj( (X,Y), (X,Y + 1)) :- row(X), col(Y), col(Y + 1).
% crear adyacencia vertical, no se crea si no existe una fila debajo
adj( (X,Y), (X + 1,Y)) :- row(X), col(Y), row(X + 1).

{edge(X,Y)} :- adj(X,Y). %generar posibles aristas
edge(X,Y) :- edge(Y,X). % en los dos sentidos
seg(P,P') :- edge(P,P'), P<P'. % para en el diplay mostrar solo una arista

marked(P) :- edge(P,_). % marcar todos los puntos como visitados



% dado un punto eliminar casos en los que tiene un numero distinto de dos aristas
:- marked(P), #count{P':edge(P,P')}!=2.

% el bucle debe pasar por todos los puntos black y white
:- blackCoor(P), not marked(P).
:- whiteCoor(P), not marked(P).

% obtenemos que puntos son rectos
%
%   (X2,Y2)    P    (X1,Y1)
%      O - - - O - - - 0
%
recto_h(P) :- marked(P), edge (P, (X1, Y1)), edge ((X2, Y2), P), |Y2-Y1| == 2. % rectos horizontalmente
recto_v(P) :- marked(P), edge (P, (X1, Y1)), edge ((X2, Y2), P), |X2-X1| == 2. % rectos verticalmente

% obtenemos puntos que son esquina (los que no son rectos)
codo(P) :- marked(P), not recto_h(P), not recto_v(P).

% los blancos deben ser rectos
:- marked(P), codo(P), whiteCoor(P).

%los negros deben ser esquina
:- marked(P), not codo(P), blackCoor(P).













