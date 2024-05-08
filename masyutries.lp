% Definir el tamaño del tablero de Masyu
tamano(5, 5).

% Definir las perlas blancas y negras con sus coordenadas (x, y)
perla_blanca(2, 3).
perla_negra(4, 2).

% Reglas para las perlas blancas
{ camino(X, Y) } :- perla_blanca(X, Y).
:- perla_blanca(X, Y), not { camino(X-1, Y); camino(X+1, Y); camino(X, Y-1); camino(X, Y+1) }.

% Reglas para las perlas negras
{ camino(X, Y) } :- perla_negra(X, Y).
:- perla_negra(X, Y), not { camino(X-2, Y); camino(X+2, Y); camino(X, Y-2); camino(X, Y+2) }.

% Conectar el camino
:- camino(X, Y), not { camino(X-1, Y); camino(X+1, Y); camino(X, Y-1); camino(X, Y+1) }.

% Evitar ciclos y asegurar un solo camino continuo
:- camino(X, Y), camino(X1, Y1), X != X1, Y != Y1.

% Visualizar la solución
#show camino/2.
