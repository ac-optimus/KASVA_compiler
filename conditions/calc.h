/* Data type for links in the chain of symbols.      */
struct symrec
{
  char *name;  /* name of symbol                     */
  char addr[100];           /* value of a VAR          */
  struct symrec *next;    /* link field              */
};

typedef struct symrec symrec;

/* The symbol table: a chain of `struct symrec'.     */
extern symrec *sym_table;

symrec *putsym ();
symrec *getsym ();




struct StmtsNode{
  // a statement is basically a single statement followed by multiple statements.
  int singl; // what is the use of this? --> to check if we have just one line of statement.
  struct StmtNode *left;
  struct StmtsNode *right;
};


struct StmtNode{
  int stmntType; // 0: assignment, 1: While, 2: conditional, 3: for, 4: func, 5: print, 6: input
  char initCode[100];
  char elseJumpCode[20];
  // char exitJumpCode[20]; // unconditional jump from if condtion. Actually this may be redundant. Have a look.
  char assignCode[1000]; // for assignment code
  struct StmtsNode *conditionCode;
  struct StmtNode *initCode_for_variable;  // iterator variable of for loop.
  struct StmtsNode *elseCode;
};
