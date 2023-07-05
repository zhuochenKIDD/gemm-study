#include <sys/time.h>
#include <cstdio>
#define K 4


#define M K
#define N K

#define FLOPS 2*K*K*K


static double NowMicros() {
  struct timeval tv;
  gettimeofday(&tv, nullptr);
  return static_cast<uint64>(tv.tv_sec) * 1000000 + tv.tv_usec;
}

void matmul0(float *a, float *b, float *c) {
    for(int i=0; i<M; i++) {
        for(int j=0; j<N; j++) {
            float sum = 0.0f;
            for(int k=0; k< K; k++) {
                sum += a[K * i + k] * b[N * k + j];
            }
            *(c + N*i + j) = sum;
        }
    }
}

void init_abc(float *a, float *b, float *c) {
    int cnt = 1;
    for(int i = 0; i < K; i++) {
        for(int j = 0; j < K; j++) {
            a[i*K + j] = 0.1 * cnt ++;
            b[i*K + j] = 0.0;
            if (i == j) {
                b[i*K + j] = 1;
            }
        }
    }
}


void print_mat(float *m) {
    for(int i = 0; i < M; i++) {
      for(int j = 0; j < N; j++) {
        printf("%f, ", m[N*i + j]);
      }
      printf("\n");
    }
}


int main() {
    float a[M * K], b[K * N], c[M * N];
    init_abc(a, b, c);

    print_mat(a);
    print_mat(b);

    matmul0(a, b, c);

    print_mat(c);



    printf("FLOPS is %d", FLOPS);
    return 0;
}