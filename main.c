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
    printf("1 - DGEMM sem otimização.\n");
    printf("\n\n");
    printf("Digite sua opção: ");
    scanf("%d", &opcao);
    printf("\n\n\n\n\n\n\n\n\n");

    switch (opcao){
        case 1:
            printf("1 - DGEMM sem otimização\n\n");
            test_dgemm(n, dgemm_first);
        break;

        default:
            printf("Opção inválida\n");
    }
}