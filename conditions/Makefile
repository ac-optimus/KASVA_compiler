final: calc.tab.c lex.yy.c
    gcc -o KASVA.out calc.tab.c lex.yy.c -lfl

calc.tab.c: calc.yy
    bison calc.y -d

lex.yy.c: tok.l
    flex tok.l

clean:
    rm calc.tab.c lex.yy.c calc.tab.h