
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <mma.h>

#include "cuda_runtime.h"
#include "device_launch_parameters.h"


#define ROWS 16*3
#define COLS 16*3



__global__ void convertFp32ToFp16 (half *out, float *in, int n) {
   int idx = blockDim.x * blockIdx.x + threadIdx.x;
   if (idx < n) {
      out[idx] = in[idx];
   }
}

using namespace nvcuda;


half * to_half(float *vetor, int tamanho){
   float *cuda_vet;
   half *half_vet;
   cudaMalloc(&cuda_vet,  tamanho);
   cudaMemcpy(cuda_vet, vetor, tamanho, cudaMemcpyHostToDevice);
   free(vetor);
   cudaMalloc(&half_vet,  tamanho);
   convertFp32ToFp16<<<(tamanho)/32 + 1,32>>>(half_vet, cuda_vet, tamanho);
   
   cudaFree(cuda_vet);

  
   return half_vet;

}

int main(){
   float *vetor;
   int tam = ROWS * COLS * sizeof(float);
   vetor =(float*) malloc(tam);
   for(int i = 0 ; i < 100; i++) vetor[i] = 1;
   half *half_vet1 = to_half(vetor, tam);

   vetor =(float*) malloc(tam);
   for(int i = 0 ; i < 100; i++) vetor[i] = 1;
   half *half_vet2 = to_half(vetor, tam);


   cudaFree(half_vet1);
   cudaFree(half_vet2);
   
}