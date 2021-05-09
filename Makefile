all:	run

run:	calc.tab.c lex.yy.c
	@echo "building..."
	@echo "run ./KASVA < filname"
	@gcc -o KASVA calc.tab.c lex.yy.c -lfl

calc.tab.c:	calc.y
	@bison calc.y -d

lex.yy.c:	tok.l
	@flex tok.l

clean:
	@echo "uninstalling..."
	@rm calc.tab.c lex.yy.c calc.tab.h KASVA asmb.asm