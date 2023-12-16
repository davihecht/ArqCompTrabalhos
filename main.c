#include "evaluate_dgemm.h"
#include "dgemm.h"
#include <stdio.h>



int main(int argc, char* argv[ ]){
    size_t n;
    char *err;
    int opcao;

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

    printf("\nDGEMM:\n");
    printf("1 - DGEMM sem otimizacao.\n");
    printf("2 - DGEMM com instrucoes AVX.\n");
    printf("3 - DGEMM com instrucoes AVX e Loop Unrolling.\n");
    printf("4 - DGEMM com instrucoes AVX,Loop Unrolling e Cache Blocking.\n");
    printf("5 - DGEMM com instrucoes AVX,Loop Unrolling,Cache Blocking e Multiple Processors.\n");

    printf("\n\n");
    printf("Digite sua opcao: ");
    scanf("%d", &opcao);
    printf("\n\n\n\n\n\n\n\n\n");

    switch (opcao){
        case 1:
            printf("1 - DGEMM sem otimizacao\n\n");
            test_dgemm(n, dgemm_1);
        break;

        case 2:
            printf("2 - DGEMM com instrucoes AVX.\n");
            test_dgemm(n, dgemm_2);
        break;

        case 3:
            printf("3 - DGEMM com instrucoes AVX e Loop Unrolling.\n");
            test_dgemm(n, dgemm_3);
        break;
        case 4:
            printf("4 - DGEMM com instrucoes AVX,Loop Unrolling e Cache Blocking.\n");
            test_dgemm(n, dgemm_4);
        break;
        case 5:
            printf("5 - DGEMM com instrucoes AVX,Loop Unrolling, Cache Blocking e Multiple Processors.\n");
            test_dgemm(n, dgemm_5);
        break;

        default:
            printf("Opcao invalida\n");
    }
}