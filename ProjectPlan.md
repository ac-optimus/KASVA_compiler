# Project plan.
- The bare minimum features that should be present in your language are:
    - conditional
    - loops (for and while)
    - Arrays
    - function call (parameter passing, return facilities)
    - basic input/output capability.
- Provide support to just one data type at the initial stage -- int, float (both are 4 bytes)
- We can modify the straight line grammar that is provided to us. Make all the necessary changes in that
- Options to end each of the statements
    - New line
    - Semicolon
    - Use parentheses as c
    - Indentation as in python
- Sit and finalize the syntax of our programming language.
- Implement these first then we can try register allocation, etc.



# Syntax
###

= assignment

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