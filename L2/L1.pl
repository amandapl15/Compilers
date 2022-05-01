%Amanda Pintado Lineros u137702 NIA195285

%Compilado mediante SWI-Prolog online: https://swish.swi-prolog.org/

%------------Ex1-----------
%a
%El lenguage es toda combinacion de suma y multiplicacion con sus parentesis

%b
%Ahora indicamos las relas con rule del apartado anterior
rule(n(e),[n(g),n(e1)]).
rule(n(e1),[t(+),n(g),n(e1)]). %or
rule(n(e1),[]).
rule(n(g),[n(f),n(g1)]).
rule(n(g1),[t(*),n(f),n(g1)]). %or
rule(n(g1),[]).
rule(n(f),[t('('),n(e),t(')')]). %or
rule(n(f),[t(a)]). %or
rule(n(f),[t(b)]). %or
rule(n(f),[t(c)]). %or
rule(n(f),[t(d)]).

%con el parse se iran guardando las reglas ejecutadas en un stack
parse([],[]).
parse(X,[n(Y)|Stack]):- rule(n(Y),R), 
    append(R,Stack,NStack), parse(X,NStack).
parse([t(Z)|NStack],[t(Z)|R2]):- parse(NStack,R2).

%parse([t(+),t(a),t(b)],[n(e)]).
%false
%parse([t(a),t(+),t(b)],[n(e)]).
%true

%------------Ex2-----------
%respresentacion del automata
initial(1).
final(4).
arc(1,2,j).
arc(2,1,a).
arc(2,3,a).
arc(3,4,!).

%recognize
%es parecido a una lista, de la que tomamos el head y separamos su cola
r(NODE,[]):- final(NODE).
r(NODE,[HY|TY]):- arc(NODE,X,HY), r(X,TY).

%comprobamos que el elemento este entre los nodos, como en una lista
recognize([]).
recognize(X):- initial(NODE),r(NODE,X).

%generate
%primero se reconocen los elementos, el generate entonces reconocera todo
rec(X,Y):- initial(X), recognize(Y).
generate(X,Y):- rec(X,Y).
