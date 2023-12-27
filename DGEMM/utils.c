#include "utils.h"
#include <time.h>


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