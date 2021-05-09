# A Simple Compiler

In this project, we write a compiler having features and syntax as mentioned below. We use Flex for generating lexical analyser and, Bison for generating parser for the language. We use MARS simulator for assembly output on MIPS architecture.

## How to build?
1. Open terminal in conditions folder in the reporsitory.
2. Run the command - $flex tok.l
3. Run the command - $bison -d calc.y
4. Run the command - $gcc calc.tab.c lex.yy.c -lfl
5. Open asmb.asm file in Mars. Assemble and Run.

## Features included
1. Data Type Supported - Int
2. Integer assignment and access
3. Array assignment, access
4. If-else
5. Conditionals (EQ, GE, LE, LT, GT)
6. Loops (For and While)
7. Function
8. Integer input and output
9. Single line comments

## Syntax
### assignment
```c
a = 10;

```

### input
```c
a = scanf();

```

### print
```c 
printf(a);

```

### single line comment
```c
// this is a comment

```

### arrays
```c
drgndf

```

### if else
```c
if (var1 < var){
    m=m+n;
}
else{
    n=0;
}

```

### while
```c

while(m<n){
    temp=fprev;
    fprev=fnext;
    fnext=temp+fnext;
    m=m+1;
}

```

### for
```c
for (var; upper_bound; increment)  // for now
for (i; i<upper; i=i+1){
}
// note - upper must be a register.
```

### function
```py
# tentetive
def functionName(i, j, k){
        stmts
}

def name(a){
    return a+1;
}


funcStmt: DEF VAR '(' parameters  ')' '{'  stmts  '}'
paramters: VAR parameters
         | VAR
         |  /* void */
```

## Contributors
- <a href = "https://github.com/ac-optimus">Abhavya Chandra ()</a> 
- <a href = "https://github.com/sgdesh">Shubham Deshpande ()</a>
- <a href = "https://github.com/vandanpatel105">Vandan Patel (17110105)</a>
- <a href = "https://github.com/kanishkkalra11">Kanishk Kalra (17110067)</a>
