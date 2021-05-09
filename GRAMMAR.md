# Non-Terminals
- prog
- declBlock
- decls
- decl
- stmts
- stmt
- assignStmt
- ifElseStmt
- whileStmt
- forStmt
- funcStmt
- parameters
- returnStmt
- inputStmt
- printStmt
- arrayStmt
- exp
- relation_operator
- x

# Terminals
- WHILE
- IF
- ELSE
- FOR
- DEF
- RETURN
- DECL
- STARTDECL
- ENDDECL
- NUM
- VAR
- SCAN
- PRINT

# Grammer:

- **prog**:                   declBlock stmts | stmts
- **declBlock**:              STARTDECL '\n' decls  ENDDECL '\n'
- **decls**:                  decl | decl decls
- **decl**:                   DECL VAR '[' NUM ']' ';' '\n'
- **stmts**:                  stmt |stmt stmts
- **stmt**:                   '\n' | assignStmt ';' | whileStmt | ifElseStmt | funcStmt | returnStmt | forStmt | inputStmt | printStmt | arrayStmt | error '\n'
- **inputStmt**:              VAR ASSIGN SCAN '(' ')' ';'
- **printStmt**:              PRINT '('  exp  ')' ';'
- **forStmt**:                FOR '('  assignStmt ';'relation_operator  ';' assignStmt ')' '{' stmts '}'
- **assignStmt**:             VAR ASSIGN exp
- **whileStmt**:              WHILE '(' relation_operator ')' '{' stmts '}'
- **ifElseStmt**:             IF '('relation_operator ')' '{' stmts '}' '\n' ELSE '{' stmts '}'
- **funcStmt**:               DEF VAR '(' parameters  ')' '{'  stmts '}'
- **parameters**:             VAR ',' parameters | VAR
- **returnStmt**:             RETURN x ';'
- **arrayStmt**:              VAR '[' x ']' '=' VAR '[' x ']' | VAR '[' x ']' '=' exp
- **relation_operator**:      VAR EQ VAR | VAR LT_OP VAR | VAR GT_OP VAR | VAR LE_OP VAR | VAR GE_OP VAR
- **exp**:                    x | x '+' x | x '-' x | x '*' x | x '/' x
- **x**:                      NUM | VAR