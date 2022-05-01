%Amanda Pintado Lineros u137702 NIA195285

%Compilado mediante SWI-Prolog online: https://swish.swi-prolog.org/

%------------Ex1-----------
%1 a X is the head of Y
miembro(X,[X|_]).
%miembro(1,[1,2,3])
%1 b X is a member of the tail of Y
miembro(X,[_|T]):- miembro(X,T).
%miembro(2,[1,2,3])

%2
anade(X,Y,[X|Y]).
%anade(1,[2,3],Z)

%3
quita(X,[X|T],T). 
%base case: X es el head, asi que conservamos solo tail T
quita(X,[H|TX],[H|TZ]):- quita(X,TX,TZ). 
%X esta en tail TX, hacemos una llamada concurrente y conservamos head H, creamos un nuevo tail TZ sin X
%quita(1,[1,2,3],Z)

%4
concatena([],Y,Y).
%base case: la lista esta vacia asi que conservamos el elemento
concatena([H|TX],Y,[H|TZ]):- concatena(TX,Y,TZ).
%tomamos tail de la primera lista para concatenar con tail Z de la segunda lista, 
%conservamos Y para concatenarlo
%concatena([1,2],[3,4],Z)

%5
%hay que comprobar si la primera lista X es parte de la segunda lista Y
sublista([],[]).
%base case 1: ambas listas estan vacias
sublista([H|TX],[H|TY]):- sublista(TX,TY).
%dos listas con el mismo head H, tomamos sus colas e ignoramos este H
sublista(X, [_|TY]):- sublista(X,TY).
%tomamos la lista X y la tail TY de la segunda lista
%sublista([2,3],[1,2,3,4])

%------------Ex2-----------

%definiremos cada casa con Color, Nacionality y Pet ademas de cada calle por una 
%House1, 2 y 3

%evita coincidencias de  parametros que vamos a definir
different(A,B,C):- A\=B,A\=C,B\=C.

solution(Street):-
    %Street = [House1,House2,House3] y cada house se define como house(Color,Nationality,Pet)
    Street = [house(Color1,Nationality1,Pet1),house(Color2,Nationality2,Pet2),house(Color3,Nationality3,Pet3)],
    %deberemos definir cada posibilidad de Color, Nationality, Pet
    %posibilidades de Color
    miembro(Color1,[red,blue,green]),
    miembro(Color2,[red,blue,green]),
    miembro(Color3,[red,blue,green]),
    %posibilidades de Nationality
    miembro(Nationality1,[spanish,english,japanese]),
    miembro(Nationality2,[spanish,english,japanese]),
    miembro(Nationality3,[spanish,english,japanese]),
    %posibilidades de Pet
    miembro(Pet1,[frog,snail,jaguar]),
    miembro(Pet2,[frog,snail,jaguar]),
    miembro(Pet3,[frog,snail,jaguar]),
    %definimos los facts que nos dice el anunciado
    %The Englishman lives in the red house
    miembro(house(red,english,_),Street),
    %The jaguar is the pet of the Spanish family
    miembro(house(_,spanish,jaguar),Street),
    %The Japanese lives to the right of the snail keeper
    %en este caso, necesitaremos la sublista para definir una casa separada de esta
    %definimos primero la casa con un caracol para que este a la izquierda y el japones viva a la derecha
    sublista([house(_,_,snail),house(_,japanese,_)],Street),
    %The snail keeper lives to the right of the blue house
    %definimos primero la casa azul para que este a la izquierda y la casa con un caracol viva a la derecha
    sublista([house(blue,_,_),house(_,_,snail)],Street),
    	
    %tenemos que evitar repericion de los parametros
    different(Color1,Color2,Color3),
    different(Nationality1,Nationality2,Nationality3),
    different(Pet1,Pet2,Pet3).
%con estas sentenicas deberiamos obtener:
%Street=[house(blue,spanish,jaguar),house(red,english,snail),house(green,japanese,frog)]
%solution(Street)

%------------Ex3-----------

different2(A,B,C,D):- A\=B,A\=C,A\=D,B\=C,B\=D,C\=D.

solution2(sudoku):-
    %sudoku = [(A1,A2,A3, A4), (B1,B2,B3,B4), (C1,C2,C3,C4), (D1,D2,D3,D4)],
    sudoku = (A1,A2, A3,A4,
 	B1,B2, B3,B4,
	C1,C2, C3,C4,
 	D1,D2, D3,D4),
    %definimos cada posibilidad de valor para cada columna
    %A column
    miembro(A1,[1,2,3,4]),
    miembro(A2,[1,2,3,4]),
    miembro(A3,[1,2,3,4]),
    miembro(A4,[1,2,3,4]),
    %B column
    miembro(B1,[1,2,3,4]),
    miembro(B2,[1,2,3,4]),
    miembro(B3,[1,2,3,4]),
    miembro(B4,[1,2,3,4]),
    %C column
    miembro(C1,[1,2,3,4]),
    miembro(C2,[1,2,3,4]),
    miembro(C3,[1,2,3,4]),
    miembro(C4,[1,2,3,4]),
    %D column
    miembro(D1,[1,2,3,4]),
    miembro(D2,[1,2,3,4]),
    miembro(D3,[1,2,3,4]),
    miembro(D4,[1,2,3,4]),
    %y ahora ponemos las restricciones con el different2, como es un sudoku debemos 
    %evitar repeticion por fila
    different2(A1, B1, C1, D1),
    different2(A2, B2, C2, D2),
	different2(A3, B3, C3, D3),
    different2(A4, B4, C4, D4),
	%evitar repeticion por columna
    different2(A1, A2, A3, A4),
    different2(B1, B2, B3, B4),
    different2(C1, C2, C3, C4),
    different2(D1, D2, D3, D4),
    %evitar repeticion por subrecuadro
    different2(A1, A2, B1, B2),
    different2(A3, A4, B3, B4),
    different2(C1, C2, D1, D2),
    different2(C3, C4, D3, D4),
    print(A1,A2,A3,A4,B1,B2,B3,B4,C1,C2,C3,C4,D1,D2,D3,D4).
    
    
