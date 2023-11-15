#include "dgemm.h"
#include <x86intrin.h>
#include <stdio.h>


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

void dgemm_second (size_t n, double* A, double* B, double* C){
    printf("Chegou aqui\n");
    for (size_t i = 0; i < n; ++i)
        for (size_t j = 0; j < n; ++j){
            printf("Chegou aqui\n");
            __m256d c0 = _mm256_load_pd(C+i+j*n);
            printf("Chegou aqui\n");
            for (size_t k = 0; k < n; k++){
                c0 = _mm256_add_pd(c0, 
                    _mm256_mul_pd(
                        _mm256_load_pd(A+i+k*n),
                        _mm256_broadcast_sd(B+k+j*n)
                    )
                );
            }
            _mm256_store_pd(C+i+j*n, c0);
        }
}