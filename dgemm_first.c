#include <stdio.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>
#ifdef __linux__ 
#include <unistd.h>
#endif

#ifdef __WIN32
#include <windows.h>
#endif



void dgemm (size_t n, double* A, double* B, double* C){
    for (size_t i = 0; i < n; ++i)
        for (size_t j = 0; j < n; ++j){
            double cij = C[i + j*n];
            for (size_t k = 0; k < n; k++){
                cij += A[i + k*n] * B[k + j*n];
            }
            C[i + j*n] = cij;
        }
}

void initialize_vector(size_t n, double* Vector){
    time_t t;

    /* Intializes random number generator */
    srand((unsigned) time(&t));

    for (size_t i = 0; i < n; i++){
        Vector[i] = (double)(rand() % 1000)/133;
    }
}

void print_firsts_values(size_t count, double* Vector){
    for (size_t i = 0; i < count; i++)
        printf("%f, ", Vector[i]);
    printf("\n");
}


int main(int argc, char *argv[ ]){
    size_t n;
    char *err;

    // Get the "n" value from the call
    if (argc > 2){
        printf("\nNumber of arguments invalid");
        return 0;
    }
    if (argc == 2){
        n = strtol(argv[1], &err, 10);
        if (strcmp(err, "\0") != 0){
            printf("\nCharacter '%c' invalid", *err);
            exit(1);
        } 
    }
    else
        n = 1000;

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
    dgemm(n, A, B, C);
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
        dgemm(n, A, B, C);
        end = clock();
        time_spent += (double)(end - begin) / CLOCKS_PER_SEC;
    }
    printf("\nTime spent: %f seconds\n", time_spent/i);
    return 0;
}
