## Execution
1 - Build main program

```
make dgemm
```

2 - Run it specifying or not "n" (matrix order). Default n = 1000
```
./dgemm <n>
```
or 
```
./dgemm
```

## Add new function

1 - Add other dgemm algorithm in "dgemms.c" and include it in dgemm.h
2 - Add call to it algorithm in "main.c" using "test_dgemm" function, like:
```c
case 1:
    printf("1 - DGEMM sem otimização\n\n");
    test_dgemm(n, dgemm_first);
break;
```