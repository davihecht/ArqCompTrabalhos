#include "utils.h"
#include "evaluate_dgemm.h"
#include <time.h>
#include <x86intrin.h>
#include <string.h>
#ifdef __linux__ 
#include <unistd.h>
#endif

#ifdef _WIN32
    #include <windows.h>
#endif



int test_dgemm(size_t n, void (*func_dgemm)()){

    // Initialize vectors

    

    double *A = (double *)malloc(n*n * sizeof(double));
    double *B = (double *)malloc(n*n * sizeof(double));
    double *C = (double *)calloc(n*n, sizeof(double));

    clock_t begin;
    clock_t end;
    double time_spent;
    size_t i;

    printf("Initializing vector A and B...\n");
    initialize_vector(n*n, A);
    
    // Sleep to change srand seed
    #ifdef __linux__ 
    sleep(1);
    #endif
    #ifdef __WIN32 
    Sleep(1000);
    #endif

    initialize_vector(n*n, B);

    printf("\nFirsts 10 values in A:\n");
    print_firsts_values(10, A);

    printf("Firsts 10 values in B:\n");
    print_firsts_values(10, B);

    printf("Firsts 10 values in C:\n");
    print_firsts_values(10, C);

    printf("\nUsing DGEMM to calculate C = C + A*B...\n");
    
    begin = clock();
    (*func_dgemm)(n, A, B, C);
    end = clock();
    time_spent = (double)(end - begin) / CLOCKS_PER_SEC;

    printf("\nFirsts 10 values in C after dgemm:\n");
    print_firsts_values(10, C);
    printf("\nTime spent: %f seconds\n", time_spent);

    printf("\nRunning DGEMM 10 times to calculate the mean time...\n");
    time_spent = 0;
    for (i = 0; i < 10; i++){
        memset(C, 0, n*n * sizeof(double));
        begin = clock();
        (*func_dgemm)(n, A, B, C);
        end = clock();
        time_spent += (double)(end - begin) / CLOCKS_PER_SEC;
    }
    printf("\nTime spent: %f seconds\n", time_spent/i);
    free(A);free(B);free(C);
    return 0;
}