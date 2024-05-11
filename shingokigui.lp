%%%%%%%%%%%%%%%%%%%% 3. White circles must be passed through in a straight line.
%%%%%%%%%%%%%%%%%

row(0..N-1) :- size(N).
col(0..N-1):- size(N).
point( (X,Y) ) :- row(X), col(Y).

adj( (X,Y), (X,Y + 1)) :- row(X), col(Y), col(Y + 1). %x es adyacente a y, y no es la ultima
adj( (X,Y), (X + 1,Y)) :- row(X), col(Y), row(X + 1). %lo mismo verticalmente

{edge(P,Q)} :- adj(P,Q).
edge(Q,P) :- edge(P,Q).

used(P) :- edge(P,_). % el primer argumento de un edge siempre es un used
:- used(P), #count{Q: edge(P,Q)} != 2. % no puede ser que si cuento el numero de edges que salen del punto de mas de dos

%%% 2. The loop must pass through all numbered circles. %%%
ball(B) :- number(B,N), N != 0.
:- ball(B), not used(B).
% no puede existir una bola en un punto que no esté usado


%%% 1. All edges must form a single, linear loop. No crossing or branching is allowed. %%%

% La condicion reach comprueba si la bola mínima es alcanzable desde el punto X
% Se utiliza la bola mínima para evitar tiempos de calculo elevados con problemas de grandes dimensiones,
% si se utilizan el doble de variables, el tiempo de calculo aumenta exponencialmente
reach (X) :- M = #min{B: ball(B)}, edge (X, M).
reach (X) :- edge (X, Y), reach(Y).
% Si se usa un punto ha de poder alcanzar la bola mjínima
:- used (P), not reach (P).



%%% 3. White circles must be passed through in a straight line. %%%
%%% 4. Black circles must always be in the corner of a turn.    %%%

% Se comprueba para cada bola si tiene los edges salientes alineados horizontalmente (condicion de bola blanca)
whitecond (B)   :- ball(B), edge (B, (X1, Y1)), edge (B, (X2, Y2)), |Y1-Y2| == 2.
whitecond (B)   :- ball(B), edge (B, (X1, Y1)), edge (B, (X2, Y2)), |X1-X2| == 2.

%Si N es positivo (N>=2) , la bola es blanca, no puede darse el caso de que la bola sea blanca y no tenga los edges alineados
:- number (B, N), N > 1, not whitecond (B).

%El caso contrario con las bolas negras, no puede ser que N sea negativo y los edges estén alineados
:- number (B, N), N < 0, whitecond (B).



%%% 5. The number in each circle must be the sum of the lengths of the 2 straight lines segments going out of that circle. %%%

%align(B, P):- ball(B), edge(B,P). Align funciona con aristas en lugar de con puntos, ya que las aristas nos ofrecen mas información (la dirección, vertical u horizontal)
%si tengo una edge alineado a uno ya alineado, tambien está alineado. Si hago un count de todas los edges que cumplen align (B,P) el numero ha de ser el de la bola en valor absoluto
hor_aligned((X1,Y1), (X2,Y2), (X3,Y3)) :- edge((X1,Y1), (X2,Y2)), edge((X2,Y2), (X3,Y3)), Y1 != Y3, X1 = X2, X2 = X3. % se comprueba que la columna no sea la misma pero las filas si (caso horizontal)
ver_aligned((X1,Y1), (X2,Y2), (X3,Y3)) :- edge((X1,Y1), (X2,Y2)), edge((X2,Y2), (X3,Y3)), X1 != X3, Y1 = Y2, Y2 = Y3. % se comprueba que las fila no sea la misma pero las filas si (caso vertical)

edge_aligned (P1,P2,P3):- hor_aligned(P1,P2,P3).
edge_aligned (P1,P2,P3):- ver_aligned(P1,P2,P3).

align(B,B,P) :- ball(B), edge(B,P). % las aristas salientes de las bolas SIEMPRE están alineados con la misma
align(P1,P2,P3) :- edge_aligned(X,P2,P3), align(P1,X,P2).  % las aristas alineadas con alguna arista alineada a una bola, también están alineadas


% Cuenta cuantos edges(X,Y) están alineados con la bola B, ese numero de edges tiene que, evidentemente, ser el numero indicado en la bola
% No se puede dar el caso de que el numero de aristas no sea igual que el numero de la bola
:- number(B,N), ball(B), C=#count{X,Y:align(B,X,Y)}, |C|!=|N|.




seg(P,Q) :- edge(P,Q), P < Q. % renombramos los edges a segmentos para mayor sencillez a la hora de mostrar el output