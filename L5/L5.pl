%Amanda Pintado Lineros u137702 NIA195285

%Compilado mediante SWI-Prolog online: https://swish.swi-prolog.org/

%Para el diccionario, tomamos primero las instruccion lookup que creamos 
%el lab 4
lookup(Word,dic(Word,Value,_,_),Value):-!.
lookup(Word,dic(Word2,_,L,_),Value):- Word @< Word2, lookup(Word,L,Value).
lookup(Word,dic(Word2,_,_,R),Value):- Word2 @< Word, lookup(Word,R,Value).
%declaramos las operaciones de ensamblador, como hicimos en el lab 4
opc(+, addc).
opc(-, subc).
opc('*',mulc).
opc('/',divc).
opv(+, add).
opv(-, sub).
opv('*',mult).
opv('/',div).
%añadimos expresiones de arithmetic memory
opx(+,add).
opx(-,sub).
opx(*,mul).
opx(/,div).
%tambien los booleanos para el test
opj(=, jumpne).
opj(<, jumpge).
opj(>, jumplt).

%usamos lo visto en el lab 4
%base para constantes
encodeexpr(const(Number),_,instr(loadc,Number)).
%base para name, variables
%como son variables, usaremos el diccionario para mirar
encodeexpr(name(Variable),Dict,instr(load,Addr)):- 
    lookup(Variable,Dict,Addr).
%recursivos para los expresion
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

%------------test------------
encodetest(test(OpBoolean,Arg1,Arg2),D,JumpLabel, (Ecode; 
                instr(OpBooleanAssembly,JumpLabel))):- 
    encodeexpr(expr(-,Arg1,Arg2),D, Ecode), 
    opj(OpBoolean,OpBooleanAssembly).

%------------if------------
encodestatement(assign(name(Variable),Expr),Dict,(E_code ; 
                instr(store,Addr))):-
    lookup(Variable,Dict,Addr), encodeexpr(Expr,Dict,E_code).

encodestatement(if(Test,Then,Else),D,(Testcode;Thencode;
                instr(jump,L2);label(L1);Elsecode;label(L2))):-
		encodetest(Test,D,L1,Testcode), encodestatement(Then,D,Thencode),
		encodestatement(Else,D,Elsecode).

%------------while------------
encodestatement(while(Test,Then),D,(label(L2);Testcode;Thencode;
                instr(jump,L2);label(L1))):-
		encodetest(Test,D,L1,Testcode),	encodestatement(Then,D,Thencode).

%------------read and write------------
encodestatement(read(name(X)),D,instr(read,Addr)):- lookup(X,D,Addr).
encodestatement(write(Expr),D,(Ecode;instr(write,0))):- 
    encodeexpr(Expr,D,Ecode).

%------------sequence------------
encodestatement((S1;S2),D,(Code1;Code2)):- 
    encodestatement(S1,D,Code1), encodestatement(S2,D,Code2).

%------------Testing------------
%encodestatement(if(test(=,name(x),const(5)), 
%	assign(name(x),const(1)), assign(name(x),const(2))),D,X).

%encodestatement(while(test(=,name(x),const(5)),
%	assign(name(x),expr(+,name(x),const(1)))),D,X).

%encodestatement((read(name(x));write(expr(+,name(x),const(1)))),D,X).