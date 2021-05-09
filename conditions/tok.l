%{
#include "calc.tab.h"
#include "calc.h"
#include<stdlib.h>
#include <stdio.h>
#include <string.h>

int Adr=0;
symrec *sym_table = (symrec *)0;
%}
number [0-9]+
id [a-z]+([a-z]|[0-9])*

%%
[ ] {}
"for" {return FOR;}
"while" {return WHILE;/*NOTHING TO ASSIGN*/}
"if" {return IF;}
"else" {return ELSE;}
"def" {return DEF;}
"return" {return RETURN;}
"startdecl" {printf("%s\n", yytext); return STARTDECL;}
"decl" {printf("%s\n", yytext); return DECL;}
"enddecl" {printf("%s\n", yytext); return ENDDECL;}

"==" {return EQ;}
"=" {return ASSIGN;}
"<" {return LT_OP;}
">" {return GT_OP;}
"<=" {return LE_OP;}
">=" {return GE_OP;}



{number} {sscanf(yytext,"%d",&yylval.val);return NUM;}

"printf"  {return PRINT;}
"scanf"  {return SCAN;}

{id} {symrec *s;s=getsym(yytext); if(s==0) s=putsym(yytext,VAR);yylval.tptr=s;return VAR;}
\n|.  {return yytext[0];}
%%

/* The symbol table: a chain of `struct symrec'.  */


symrec * putsym (char *sym_name,int sym_type){
  symrec *ptr;
  ptr = (symrec *) malloc (sizeof (symrec));
  ptr->name = (char *) malloc (strlen (sym_name) + 1);
  strcpy (ptr->name,sym_name);
  sprintf(ptr->addr,"%d",Adr); /* set value to 0 even if fctn.  */
  Adr=Adr+4;
  ptr->next = (struct symrec *)sym_table;
  sym_table = ptr;
  return ptr;
}

symrec *getsym (char *sym_name){
  symrec *ptr;
  for (ptr = sym_table; ptr != (symrec *) 0;
       ptr = (symrec *)ptr->next)
    if (strcmp (ptr->name,sym_name) == 0)
      return ptr;
  return 0;
}
