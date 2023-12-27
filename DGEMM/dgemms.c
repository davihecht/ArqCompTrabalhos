#include "dgemm.h"
#include <x86intrin.h>
#include <stdio.h>
#include <omp.h>

#define UNROLL (4)
#define BLOCKSIZE 32
#define P 8

//não otimizado
void dgemm_1 (size_t n, double* A, double* B, double* C){
    for (size_t i = 0; i < n; ++i)
        for (size_t j = 0; j < n; ++j){
            double cij = C[i + j*n];
            for (size_t k = 0; k < n; k++){
                cij += A[i + k*n] * B[k + j*n];
            }
            C[i + j*n] = cij;
        }
}   

//instrucões avx
void dgemm_2 (size_t n, double* A, double* B, double* C){
    for (size_t i = 0; i < n; i+=4)
        for (size_t j = 0; j < n; j++)
        {
            __m256d c0 = _mm256_load_pd(C+i+j*n);
            for (size_t k = 0; k < n; k++)
            {
                c0 = _mm256_add_pd
                (c0, 
                    _mm256_mul_pd(
                        _mm256_load_pd(A+i+k*n),
                        _mm256_broadcast_sd(B+k+j*n)
                    )
                );
            }
            _mm256_store_pd(C+i+j*n, c0);
        }
}

//instrucões avx com loop unrolling

void dgemm_3 (int n, double* A, double* B, double* C)
{
    for(int i = 0;i<n;i+=UNROLL*4)
        for(int j = 0;j<n;j++){
            __m256d c[4];
        for(int x = 0;x<UNROLL;x++)
            c[x] = _mm256_load_pd(C+i+x*4+j*n);
        
        for( int k = 0; k<n;k++)
        {
            __m256d b = _mm256_broadcast_sd(B+k+j*n);
            for(int x = 0;x<UNROLL;x++)
                c[x] = _mm256_add_pd(c[x],
                _mm256_mul_pd(_mm256_load_pd(A+n*k+x*4+i),b));
        }

        for (int x = 0; x<UNROLL; x++)
            _mm256_store_pd(C+i+x*4+j*n,c[x]);

    }
}

//instrucões avx com loop unrolling e cache blocking

void do_block(int n, int si, int sj, int sk,
               double *A, double *B, double *C)
{
    for (int i = si; i < si + BLOCKSIZE; i += UNROLL * 4)
        for (int j = sj; j < sj + BLOCKSIZE; j++)
        {
            __m256d c[4];
            for (int x = 0; x < UNROLL; x++)
                c[x] = _mm256_load_pd(C + i + x * 4 + j * n);
            for (int k = sk; k < sk + BLOCKSIZE; k++)
            {
                __m256d b = _mm256_broadcast_sd(B + k + j*n);
                for (int x = 0; x < UNROLL; x++)
                    c[x] = _mm256_add_pd(c[x],
                    _mm256_mul_pd(_mm256_load_pd(A+n*k+x*4+i),b));
            }

            for (int x = 0; x < UNROLL; x++)
                _mm256_store_pd(C + i + x * 4 + j * n, c[x]);

        }
}

void dgemm_4(int n, double *A, double *B, double *C)
{
    for (int sj = 0; sj < n; sj += BLOCKSIZE)
        for (int si = 0; si < n; si += BLOCKSIZE)
            for (int sk = 0; sk < n; sk += BLOCKSIZE)
                do_block(n, si, sj, sk, A, B, C);
}

//instrucões avx com loop unrolling,cache blocking e utilizando multiplos cores do processador

void dgemm_5(int n, double *A, double *B, double *C)
{
    
    #pragma omp parallel for
    for (int sj = 0; sj < n; sj += BLOCKSIZE)
        for (int si = 0; si < n; si += BLOCKSIZE)
            for (int sk = 0; sk < n; sk += BLOCKSIZE)
                do_block(n, si, sj, sk, A, B, C);
}
