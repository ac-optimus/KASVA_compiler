# KASVA Compiler

In this project, we write a compiler having features and syntax as mentioned below. We use Flex for generating lexical analyser and, Bison for generating parser for the language. We use MARS simulator for assembly output on MIPS architecture.

## How to build?
1. Open terminal in root folder in the reporsitory.
2. Run `$make`
3. Some test files are available in the folder `conditions`. To test on `filename.ksva`, run `$./KASVA < conditions/filname.kasva`
4. Open `asmb.asm` file in Mars. Assemble and Run.

## Features included
1. Data Type Supported - Int
2. Integer assignment and access
3. Array assignment, access (In progress)
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
/* this is a comment */

```

### if else
```c
if (var1 < var){
    m=m+n;
}
else{
    n=0;
}

// note : var1 and var must be variables.

```

### while
```c

while(m<n){
    temp=fprev;
    fprev=fnext;
    fnext=temp+fnext;
    m=m+1;
}
// note : m and n must be variables.

```

### for
```c
k=100;
for (i=0; i<k; i=i+1){
    a=a+1;
}
// note : k must be a variables.
```

### function defination
```c
def addfun(a, b){
    s=a+k;
    return s;
}

/* note : a and b must be variables
        : function defination must be at the end of program
*/
```

### function call
```py
c=addfun(a,b);
```

## Contributors
- <a href = "https://github.com/ac-optimus">Abhavya Chandra (16110001)</a>
- <a href = "https://github.com/sgdesh">Shubham Deshpande (16110050)</a>
- <a href = "https://github.com/vandanpatel105">Vandan Patel (17110105)</a>
- <a href = "https://github.com/kanishkkalra11">Kanishk Kalra (17110067)</a>
