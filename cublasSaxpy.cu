#include <cuda_runtime.h>
#include <cublas_v2.h>
#include <stdio.h>


__global__ void saxpy(const float *x, float *y, int numElements)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < numElements) {
        y[i] += 1.0 * x[i];
    }
}

int main(int argc, char **argv) {
    printf("[Saxpy CUBLAS] - Starting...\n");

    int N = 1024;
    float alpha = 1.0;
    float *d_x, *d_r;

    cublasHandle_t handle;
    cudaEvent_t start, stop;

    cublasCreate(&handle);
    cudaMalloc((void **)&d_x, N * sizeof(float));
    cudaMalloc((void **)&d_r, N * sizeof(float));

    int threadsPerBlock = 256;
    int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;
    printf("blocksPerGrid=%d, threadsPerBlock=%d", blocksPerGrid, threadsPerBlock);

    cudaEventCreate(&start);
    cudaEventCreate(&stop);


    int nIter = 30;

    cudaEventRecord(start, NULL);
    for (int i = 0; i < nIter; i++) {
        cublasSaxpy(handle, N, &alpha, d_x, 1, d_r, 1);
        saxpy<<<blocksPerGrid, threadsPerBlock>>>(d_x, d_r, N)
    }
    printf("done.\n");

    // Record the stop event
    cudaEventRecord(stop, NULL);

    // Wait for the stop event to complete
    cudaEventSynchronize(stop);

    float msecTotal = 0.0f;
    cudaEventElapsedTime(&msecTotal, start, stop);


    float msecPerSaxpy = msecTotal / nIter;

    double gFlops = (2 * N * 1.0e-9f ) / (msecPerSaxpy / 1000.0f);
    printf("Performance= %.2f GFlop/s, Time= %.3f msec, Size= %.0f Ops\n",
           gFlops, msecPerSaxpy, 2*N);


    cudaFree(d_x);
    cudaFree(d_r);
    cublasDestroy(handle);

}