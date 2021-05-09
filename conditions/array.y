/* How to compile
$bison -d calc.c
$gcc calc.tab.c
Reference: http://dinosaur.compilertools.net/bison/bison_5.html
*/

%{
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include "calc.h"  /* Contains definition of `symrec'        */
int  yylex(void);
void yyerror (char  *);

int forStart=0;
int whileStart=0;
int nextJump=0;
int ifStart=0;
int conditionNextJump=0;

int count=0; /* This can take value 0 and 1. */
int funccount =0;
int labelCount=0; // where we have used this?
FILE *fp;
struct StmtsNode* final; // is this our abstract tree?
void StmtsTrav(struct StmtsNode* ptr);
void StmtTrav(struct StmtNode* ptr);
void addNewStmtAtTheEnd(struct StmtsNode *oldStmts, struct StmtNode* newStmt);




%}
%union {
        int val;  /* For returning numbers.*/
        struct symrec *tptr;   /* For returning symbol-table pointers.*/
        char c[10000];
        char nData[100];
        struct StmtNode *stmtptr;
        struct StmtsNode *stmtsptr;

}

%token WHILE IF ELSE FOR DEF RETURN
%token  <val> NUM        /* Integer   */
%token <tptr> VAR SCAN PRINT
// %token <nData> SCAN PRINT
%type  <c>  exp
%type <nData> x
%type <stmtptr> stmt
%type <stmtptr> whileStmt
%type <stmtptr> forStmt
%type <stmtptr> assignStmt
%type <stmtptr> ifElseStmt
%type <stmtptr> relation_operator
%type <stmtsptr> stmts
%type <stmtptr>funcStmt
%type <stmtptr>returnStmt
%type <stmtptr>funcAssign
%type <stmtptr>funCall
%type <stmtptr> printStmt
%type <stmtptr> inputStmt

%right ASSIGN
%left EQ LE_OP GE_OP GT_OP LT_OP
%left '-' '+'
%left '*' '/'

/* Grammar follows */
%%
prog:  stmts   {final=$1;}
;

stmts: stmt {
                $$=(struct StmtsNode*)malloc(sizeof(struct StmtsNode));
                $$->singl=1;
                $$->left=$1;
                $$->right=NULL;
            }
        |stmt stmts
                {$$=(struct StmtsNode*)malloc(sizeof(struct StmtsNode));
                $$->singl=0;
                $$->left = $1;
                $$->right = $2;
                }
;

stmt: '\n'  {$$ = NULL;/*$$ our head is a pointer, setting it ot null here.*/}
      | assignStmt ';' {$$=$1;}
      | whileStmt {$$=$1;}
      | ifElseStmt {$$=$1;}
      | funcStmt {$$=$1;}
      | returnStmt {$$=$1;}
      | forStmt {$$=$1;}
      | inputStmt {$$=$1;}
      | printStmt {$$=$1;}
      | funCall ';' {$$=$1;}
      | funcAssign ';' {$$=$1;}
      | error '\n' { yyerrok;}

;

inputStmt: VAR ASSIGN SCAN '(' ')' ';'
                {
                $$=(struct StmtNode*)malloc(sizeof(struct StmtNode));
                $$->stmntType=0;
        	$$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
	        sprintf($$->assignCode, "li $v0, 5\nsyscall\n move $t%d, $v0\nsw $t%d %s($t8) \n",
                                                count, count, $1->addr);
        }
;

printStmt: PRINT '('  exp  ')' ';'
                {
                $$=(struct StmtNode*)malloc(sizeof(struct StmtNode));
                $$->stmntType=5;
                sprintf($$->assignCode, "%s", $3);
                }
;

forStmt: FOR '('  assignStmt ';' VAR LT_OP VAR  ';' assignStmt ')' '{' stmts '}'
                {
                //  printf("I saw a for loop.\n");
                 $$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
                 $$->stmntType = 3;
                 $$->initCode_for_variable = $3;
                 sprintf($$->initCode, "lw $t0, %s($t8)\nlw $t1, %s($t8)\n",
                         $5->addr, $7->addr);
                 sprintf($$->elseJumpCode, "bge $t0, $t1, ");
                // add assignment statement at the end of all the statements that already exists.
                 addNewStmtAtTheEnd($12, $9);
                 $$->conditionCode = $12;
                }
;

assignStmt:  VAR ASSIGN exp
                {
                // printf("assignment\n");
                 $$=(struct StmtNode*)malloc(sizeof(struct StmtNode));
                 $$->stmntType=0;
                 //sprintf($$->assignCode, "%s\nsw $t%d, %s($t8)\n", $3,count, $1->addr);
                 sprintf($$->assignCode, "%s\nsw $t0, %s($t8)\n", $3, $1->addr);
                }
;

whileStmt:  WHILE '(' relation_operator ')' '{' stmts '}'
                {
                 $$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
                 $$->stmntType = 1;
                 sprintf($$->initCode, "%s", $3->initCode);
                 sprintf($$->elseJumpCode, "%s", $3->elseJumpCode);

                 $$->conditionCode = $6;
                }
;

ifElseStmt:  IF '('relation_operator ')' '{' stmts '}' '\n' ELSE '{' stmts '}'
                {
                        /* printf("if else found\n"); */
                 $$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
                 $$->stmntType = 2;
                 sprintf($$->initCode, "%s", $3->initCode);
                 sprintf($$->elseJumpCode, "%s", $3->elseJumpCode);

                 $$->elseCode = $11;
                 $$->conditionCode = $6;
                }
;

funcStmt: DEF VAR '(' parameters  ')' '{'  stmts '}'{
        	 /* printf("function found \n"); */
                 $$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
                 $$->stmntType = 4;
                 $2->type = 1;
                 funccount =funccount +1;
                 if( funccount == 1){

         		sprintf($$->initCode, "li $v0,10 \nsyscall\n\n\n%s", $2->name);
                 }
                 else{
                 	sprintf($$->initCode, "%s", $2->name);
                 }
                 $$->conditionCode = $7;
        }
;

funCall : VAR '(' parameters  ')'{
	/* printf ("funCall found \n"); */
	//printf("%d\n",$1->type);
	$$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
	sprintf($$->assignCode,"jal %s \n", $1->name);

	}
;


funcAssign : VAR ASSIGN VAR '(' parameters  ')'{
	/* printf ("funAssign found \n"); */
	$$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
	sprintf($$->assignCode, "jal %s \nmove $t%d, $v1 \nsw $t%d %s($t8) \n",$3->name,count, count, $1->addr);
	//count=(count+1)%2;

   	}
;

parameters: VAR ',' parameters
         | VAR
;

returnStmt: RETURN VAR ';' {
     	$$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
	sprintf($$->assignCode,"lw $v1, %s($t8)\n", $2->addr);
        }
;


relation_operator: VAR EQ VAR
                        { //==
                        $$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
                        sprintf($$->initCode, "lw $t0, %s($t8)\nlw $t1, %s($t8)\n",
                                $1->addr, $3->addr);
                        sprintf($$->elseJumpCode, "bne $t0, $t1, ");
                        }
                | VAR LT_OP VAR
                        { //<
                        $$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
                        sprintf($$->initCode, "lw $t0, %s($t8)\nlw $t1, %s($t8)\n",
                                $1->addr, $3->addr);
                        sprintf($$->elseJumpCode, "bge $t0, $t1, ");
                        }
                | VAR GT_OP VAR
                        { //>
                        $$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
                        sprintf($$->initCode, "lw $t0, %s($t8)\nlw $t1, %s($t8)\n",
                                $1->addr, $3->addr);
                        sprintf($$->elseJumpCode, "ble $t0, $t1, ");
                        }
                | VAR LE_OP VAR
                        { //<=
                        $$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
                        sprintf($$->initCode, "lw $t0, %s($t8)\nlw $t1, %s($t8)\n",
                                $1->addr, $3->addr);
                        sprintf($$->elseJumpCode, "bgt $t0, $t1, ");
                        }
                | VAR GE_OP VAR
                        { //>=
                        $$=(struct StmtNode*) malloc(sizeof(struct StmtNode));
                        sprintf($$->initCode, "lw $t0, %s($t8)\nlw $t1, %s($t8)\n",
                                $1->addr, $3->addr);
                        sprintf($$->elseJumpCode, "blt $t0, $t1, ");
                        }
;

/* Invariant: we store the result of an expression in R0 */

exp:      x                { sprintf($$,"%s",$1); count=(count+1)%2;}
        | x '+' x  { sprintf($$,"%s\n%s\nadd $t0, $t0, $t1",$1,$3);}
        | x '-' x        { sprintf($$,"%s\n%s\nsub $t0, $t0, $t1",$1,$3);}
        | x '*' x        { sprintf($$,"%s\n%s\nmul $t0, $t0, $t1",$1,$3);}
        | x '/' x        { sprintf($$,"%s\n%s\ndiv $t0, $t0, $t1",$1,$3);}
;

x:   NUM {sprintf($$,"li $t%d, %d",count,$1);count=(count+1)%2;}
| VAR {sprintf($$, "lw $t%d, %s($t8)",count,$1->addr);count=(count+1)%2;}
   ;
/* End of grammar */
%%

void addNewStmtAtTheEnd(struct StmtsNode *oldStmts, struct StmtNode* newStmt){
        // add a new statement at the end of already existing statements.
        struct StmtsNode* ptr = oldStmts;
        while(ptr->right!=NULL){
                ptr=ptr->right;
        }
        // new node for statement at the end.
        ptr->singl=0;
        struct StmtsNode* newNode = (struct StmtsNode*) malloc(sizeof(struct StmtsNode));
        newNode->left = newStmt;
        ptr->right = newNode;
}

/* traversal code */
void StmtsTrav(struct StmtsNode* ptr){
        // traversing multiple statements
        /* printf("stmts\n"); // what is the point of this print? */
        if (ptr==NULL)
                return;
        if (ptr->singl == 1)
                StmtTrav(ptr->left); // ptr->rigth does not exits
        else{
                StmtTrav(ptr->left);
                StmtsTrav(ptr->right);
        }
}


void StmtTrav(struct StmtNode* ptr){
        // individual statement traversal, now we will gernerate code here.
        int cs, nj;
        if(ptr==NULL) return;
        if(ptr->stmntType == 0){
                // when statement is a single line
                fprintf(fp, "%s\n", ptr->assignCode);
                }
        else if (ptr->stmntType == 1){
                cs = whileStart;
                whileStart++;
                nj=nextJump;
                nextJump++;
                fprintf(fp, "LabStartWhile%d:\n%s\n%s NextPart%d\n",
                        cs, ptr->initCode, ptr->elseJumpCode, nj);
                StmtsTrav(ptr->conditionCode);
                fprintf(fp, "j LabStartWhile%d\nNextPart%d:\n",
                        cs, nj);
        }

        else if (ptr->stmntType == 2){
                // if else
            cs = ifStart;
            ifStart++;
            nj=conditionNextJump;
            conditionNextJump++;
            fprintf(fp, "LabStartIF%d:\n%s\n%s LabStartElse%d\n",
                    cs, ptr->initCode, ptr->elseJumpCode, nj);
            StmtsTrav(ptr->conditionCode); // body of if
            fprintf(fp, "j Exit%d\nLabStartElse%d:\n",
                    cs, nj);
            StmtsTrav(ptr->elseCode); // body of else
            fprintf(fp, "Exit%d:\n", cs);

        }

        else if (ptr->stmntType == 3){
                //for loop
                cs = forStart;
                forStart++;
                nj=nextJump;
                nextJump++;
                // StmtsTrav(ptr->initCode_for_variable);
                fprintf(fp, "%s\n", ptr->initCode_for_variable->assignCode);
                fprintf(fp, "LabStartFor%d:\n%s\n%s NextPart%d\n",
                        cs, ptr->initCode, ptr->elseJumpCode, nj);
                StmtsTrav(ptr->conditionCode);
                fprintf(fp, "j LabStartFor%d\nNextPart%d:\n",
                        cs, nj);
        }

        else if (ptr->stmntType == 4){
                fprintf(fp, "%s:\n", ptr->initCode);
                StmtsTrav(ptr->conditionCode);
                fprintf(fp,"%s","jr $ra\n");
        }
        else if (ptr->stmntType == 5){
        		fprintf(fp,"%s\n",ptr->assignCode);
        		fprintf(fp, "li $v0, 1\nmove $a0, $t0\nsyscall\n");
                        /* fprintf(fp, "li $v0, 4\nla $a0, newline\nsyscall\n"); */
        }
        // else if (ptr->stmntType == 6){
        // 		fprintf(fp, "li $v0, 5\nsyscall\n");
        // 		fprintf(fp, "$v0\n%s\n", ptr->assignCode);
        // }
}

int main ()
{
   fp=fopen("asmb.asm","w");
   fprintf(fp,".data\n\n.text\nli $t8,268500992\n");
   yyparse ();
   // Traverse the tree here
   StmtsTrav(final);
   // printing the final output.
   // check if function is not null
   // if not null then
//    fprintf(fp, "%s\n", functions);
   if( funccount == 0){
        fprintf(fp,"\nli $v0,10\nsyscall\n");
        }
   fclose(fp);
}

void yyerror (char *s)  /* Called by yyparse on error */
{
  printf ("%s\n", s);
}


