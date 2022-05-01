%Amanda Pintado Lineros 

%Compilado mediante SWI-Prolog online: https://swish.swi-prolog.org/
%------------Ex1-----------
%inicializamos las expresiones de esnamblador
opc(+, addc).
opc(-, subc).
opc('*',mulc).
opc('/',divc).
opv(+, add).
opv(-, sub).
opv('*',mult).
opv('/',div).

%del lab anterior, usamos de nuevo el parse del dicionario
lookup(Name,dic(Name,Value,_,_),Value):-!.
lookup(Name,dic(Name2,_,I,_),Value):-Name@<Name2,lookup(Name,I,Value).
lookup(Name,dic(Name2,_,_,D),Value):-Name2@<Name,lookup(Name,D,Value).

encodeexpr(const(Number),_,instr(loadc,Number)).
encodeexpr(name(Variable),Dict,instr(load,Addr)):-
    lookup(Variable,Dict,Addr).

encodestatement(assign(name(Variable),Expr),
                Dict,(E_code ; instr(store,Addr))):-
    lookup(Variable,Dict,Addr), encodeexpr(Expr,Dict,E_code).

%?-encodestatement(assign(name(x),const(a)),D,X).

%------------Ex2-----------
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
