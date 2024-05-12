
row(0..n-1).
col(0..n-1).

% traduccion blancos y negros a coordenadas por comodidad
blackCoor((Y,X\n)) :- black(X), X/n=Y.
whiteCoor((Y,X\n)) :- white(X), X/n=Y.

% crear adyacencia horizontal, no se crea si no existe una columna a la derecha
adj((X,Y), (X,Y + 1)) :- row(X), col(Y), col(Y + 1).
% crear adyacencia vertical, no se crea si no existe una fila debajo
adj((X,Y), (X + 1,Y)) :- row(X), col(Y), row(X + 1).

{edge(X,Y)} :- adj(X,Y). %generar posibles aristas
edge(X,Y) :- edge(Y,X). % en los dos sentidos

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
recto_h(P) :- marked(P), edge (P, (X1, Y1)), edge ((X2, Y2), P), Y1-Y2 == 2. % rectos horizontalmente
recto_v(P) :- marked(P), edge (P, (X1, Y1)), edge ((X2, Y2), P), X1-X2 == 2. % rectos verticalmente

% obtenemos puntos que son esquina (los que no son rectos)
codo(P) :- marked(P), not recto_h(P), not recto_v(P).

% los blancos no pueden ser esquina
:- whiteCoor(P), codo(P).
%los negros no pueden ser rectos
:- blackCoor(P), not codo(P).

% EL BUCLE DEBE SER ÚNICO
% elegimos un punto de los marcados cualquiera (minimo) y definimos su alcance
reach(X) :- M = #min{P: marked(P)}, edge (X, M).
% marcamos todos los puntos que alcanza el punto original mediante recursividad
reach(X) :- edge (X,Y), reach(Y).
% si queda algun punto marcado no alcanzable se elimina ese caso
:- marked (P), not reach (P).


% aux contiene las aristas en las direcciones izquierda a derecha y arriba a abajo
aux(P,P') :- edge(P,P'), P<P'.

% blancos deben torcer al menos una vez, 
:- whiteCoor(P), aux(P1,P), aux(P,P2), not codo(P1), not codo(P2).

% los vecinos de los negros deben ser rectas
:- blackCoor(P), aux(P1, P), codo(P1).
:- blackCoor(P), aux(P, P2), codo(P2).



% traducción de aux para el display y decode
seg(X1*n+Y1,X2*n+Y2) :- aux((X1,Y1),(X2,Y2)).





