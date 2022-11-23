
#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include <mma.h>

#include "cuda_runtime.h"
#include "device_launch_parameters.h"



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
   cudaMalloc(&cuda_vet, sizeof(float) * tamanho);
   cudaMalloc(&half_vet, sizeof(float) * tamanho);
   convertFp32ToFp16<<<(tamanho)/32 + 1,32>>>(half_vet, cuda_vet, tamanho);
   
   cudaFree(cuda_vet);

   cudaFree(half_vet);

}

int main(){
   float vetor[10] = {1,1,1,1,1,1,1,1,1,1};
   to_half()
   
}