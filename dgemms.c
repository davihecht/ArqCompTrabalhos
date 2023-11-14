#include "dgemm.h"


void dgemm_first (size_t n, double* A, double* B, double* C){
    for (size_t i = 0; i < n; ++i)
        for (size_t j = 0; j < n; ++j){
            double cij = C[i + j*n];
            for (size_t k = 0; k < n; k++){
                cij += A[i + k*n] * B[k + j*n];
            }
            C[i + j*n] = cij;
        }
}