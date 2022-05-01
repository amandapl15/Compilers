%Amanda Pintado Lineros u137702 NIA195285

%Compilado mediante SWI-Prolog online: https://swish.swi-prolog.org/

%------------Ex1-----------
%tomando lo que creamos en nuestra practica anterior
%respresentacion del automata
initial(1).
final(4).
arc(1,2,j).
arc(2,1,a).
arc(2,3,a).
arc(3,4,!).

%recognize, pero ahora lo modificamos para comprobar dos elementos 
%como en el anterior lab, la representacion es como una lista de la que separamos
%su head y su cola, y comprobamos asi que los elementos pertenezcan a la lista
r(NODE,[],[]):- final(NODE).
r(NODE1,[HY|TY],[HY,NODE2|Y]):- arc(NODE1,NODE2,HY), r(NODE2,TY,Y).
recognize(X,[NODE|TY]):- initial(NODE), r(NODE,X,TY).

%------------Ex2-----------
%modificamos la practica anterior para mejorar el parser
%especificamos primero las rules y luego creamos el parser
%modificaremos las rules para numerarlas y asi modificar el parser luego
rule(n(e),[n(g),n(e1)],1).
rule(n(e1),[t(+),n(g),n(e1)],2). %or
rule(n(e1),[],3).
rule(n(g),[n(f),n(g1)],4).
rule(n(g1),[t(*),n(f),n(g1)],5). %or
rule(n(g1),[],6).
rule(n(f),[t('('),n(e),t(')')],7). %or
rule(n(f),[t(a)],8). %or
rule(n(f),[t(b)],9). %or
rule(n(f),[t(c)],10). %or
rule(n(f),[t(d)],11).

%ampliamos el parse del lab anterior como hicimos con el recognize
parse([],[],[]).
parse(X,[n(Y)|Stack],[NUM|PATH]):- rule(n(Y),R,NUM), 
    append(R,Stack,NStack), parse(X,NStack,PATH).
parse([t(Z)|NStack],[t(Z)|R2],PATH):- parse(NStack,R2,PATH).
%parse([t(a),t(+),t(b)],[n(e)],PATH).

%------------Ex3-----------
diction(dic(sal,sel,
	dic(mostaza,moutard,
        void,
    	dic(pebre,poivre,void,void)),
	dic(vinagre,vinaigre,void,void))).

lookup(Word,dic(Word,Value,_,_),Value).
%comparacion con @<
lookup(Word,dic(Word2,_,L,_),Value):- Word @< Word2, lookup(Word,L,Value).
lookup(Word,dic(Word2,_,_,R),Value):- Word2 @< Word, lookup(Word,R,Value).
look(Word,Value):- diction(D), lookup(Word,D,Value).
