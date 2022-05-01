%Amanda Pintado Lineros 

%Compilado mediante SWI-Prolog online: https://swish.swi-prolog.org/

%Retomamos lo visto en las practicas anteriores
lookup(Word,dic(Word,Value,_,_),Value):-!.
lookup(Word,dic(Word2,_,L,_),Value):- Word @< Word2, lookup(Word,L,Value).
lookup(Word,dic(Word2,_,_,R),Value):- Word2 @< Word, lookup(Word,R,Value).

opc(+, addc).
opc(-, subc).
opc('*',mulc).
opc('/',divc).
opv(+, add).
opv(-, sub).
opv('*',mult).
opv('/',div).
opx(+,add).
opx(-,sub).
opx(*,mul).
opx(/,div).
opj(=, jumpne).
opj(<, jumpge).
opj(>, jumplt).

encodeexpr(const(Number),_,instr(loadc,Number)).
encodeexpr(name(Variable),Dict,instr(load,Addr)):- 
    lookup(Variable,Dict,Addr).

encodeexpr(expr(OperationType,name(StoreVar),
                const(Number)),D,(E_code;
                instr(OperationTypeAssembly,Number))):-
    opc(OperationType,OperationTypeAssembly),
    encodeexpr(name(StoreVar),D,E_code).

encodeexpr(expr(OperationType,const(Num1),
                const(Num2)),D,(E_code;
                instr(OperationTypeAssembly,Num2))):-
    opc(OperationType,OperationTypeAssembly),
    encodeexpr(const(Num1),D,E_code).

encodeexpr(expr(OperationType,name(StoreVar),
                name(Variable)),D,(E_code;
                instr(OperationTypeAssembly,Addr))):-
    lookup(Variable,D,Addr),
    opv(OperationType,OperationTypeAssembly),
    encodeexpr(name(StoreVar),D,E_code).

encodetest(test(OpBoolean,Arg1,Arg2),D,JumpLabel, (Ecode; 
                instr(OpBooleanAssembly,JumpLabel))):- 
    encodeexpr(expr(-,Arg1,Arg2),D, Ecode), 
    opj(OpBoolean,OpBooleanAssembly).

encodestatement(assign(name(Variable),Expr),Dict,(E_code ; 
                instr(store,Addr))):-
    lookup(Variable,Dict,Addr), encodeexpr(Expr,Dict,E_code).

encodestatement(if(Test,Then,Else),D,(Testcode;Thencode;
                instr(jump,L2);label(L1);Elsecode;label(L2))):-
		encodetest(Test,D,L1,Testcode), encodestatement(Then,D,Thencode),
		encodestatement(Else,D,Elsecode).

encodestatement(while(Test,Then),D,(label(L2);Testcode;Thencode;
                instr(jump,L2);label(L1))):-
		encodetest(Test,D,L1,Testcode),	encodestatement(Then,D,Thencode).

encodestatement(read(name(X)),D,instr(read,Addr)):- lookup(X,D,Addr).
encodestatement(write(Expr),D,(Ecode;instr(write,0))):- 
    encodeexpr(Expr,D,Ecode).

encodestatement((S1;S2),D,(Code1;Code2)):- 
    encodestatement(S1,D,Code1), encodestatement(S2,D,Code2).

%------------Ex------------

%usamos assemble para contar los comandos
%caso base, es un label, asi que no lo contamos
assemble(label(N),N,N).
%en otro caso, contamos que hay un comando
assemble(instr(_,_),N0,N):- N is N0+1.
assemble((Code1;Code2),N0,Nlast):- 
    assemble(Code1,N0,N), assemble(Code2,N,Nlast).

allocate(void,N,N):- !.
allocate(dic(_,N1,Before,After),N0,N):-
	%before esta entre N0 y N1
	allocate(Before,N0,N1),	
    N2 is N1+1,
	%after este entre N2 y N
	allocate(After,N2,N).

mprint((Code1;Code2)) :- mprint(Code1), mprint(Code2).
mprint(block(X)):- write(X), write('\t'),write(X).
mprint(instr(X,Y)):- write(X),write('\t'),write(Y),nl.
mprint(label(N)):- write('label:\t'), write(N), nl.

compile(Source):- compile(Source,Code),	mprint(Code).
compile(Source, ((Code; instr(halt,0)); block(L)) ) :-
	encodestatement(Source,D,Code), assemble(Code,1,N0),
	N1 is N0+1,	allocate(D,N1,N), L is N-N1.
