// This is the REAL "hello world" for CUDA!
// It takes the string "Hello ", prints it, then passes it to CUDA with an array
// of offsets. Then the offsets are added in parallel to produce the string "World!"
// By Ingemar Ragnemalm 2010
 
#include <stdio.h>
 
#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess) 
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

const int N = 16; 
const int blocksize = 16; 
 
__global__ 
void hello(char *a, int *b) 
{
	a[threadIdx.x] += b[threadIdx.x];
}
 
int main()
{
	char a[N] = "Hello \0\0\0\0\0\0";
	int b[N] = {15, 10, 6, 0, -11, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
 
	char *ad;
	int *bd;
	const int csize = N*sizeof(char);
	const int isize = N*sizeof(int);
 
	printf("%s", a);
 
	gpuErrchk(cudaMalloc( (void**)&ad, csize )); 
	gpuErrchk(cudaMalloc( (void**)&bd, isize )); 
	gpuErrchk(cudaMemcpy( ad, a, csize, cudaMemcpyHostToDevice )); 
	gpuErrchk(cudaMemcpy( bd, b, isize, cudaMemcpyHostToDevice )); 
	
	dim3 dimBlock( blocksize, 1 );
	dim3 dimGrid( 1, 1 );
	hello<<<dimGrid, dimBlock>>>(ad, bd);
	gpuErrchk(cudaMemcpy( a, ad, csize, cudaMemcpyDeviceToHost )); 
	gpuErrchk(cudaFree( ad ));
	
	printf("%s\n", a);
	return EXIT_SUCCESS;
}
