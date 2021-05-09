```
.data
    theArray:.space 160
.text
main:
  li    $t6, 1              # Sets t6 to 1
  li    $t7, 4              # Sets t7 to 4
  sw    $t6, theArray($0)   # Sets the first term to 1
  sw    $t6, theArray($t7)  # Sets the second term to 1
  li    $t0, 8              # Sets t0 to 8

```
```ref : https://users.cs.duke.edu/~raw/cps104/TWFNotes/html/mips.html```