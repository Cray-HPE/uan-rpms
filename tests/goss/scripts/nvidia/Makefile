CUDA_INSTALL_PATH ?=/opt/cray/nvidia/default
CUDALIB := -L${CUDA_INSTALL_PATH}/lib64 -lcuda  -lcudart -lpthread

CUDACC=nvcc

CUDA_INCLUDES := -I. -I${CUDA_INSTALL_PATH}/include

tgt:	hello

hello.o:	hello.cu
	${CUDACC} -c ${CUDA_INCLUDES} -o hello.o hello.cu

hello:	hello.o
	${CUDACC} -o $@ hello.o ${CUDALIB}

clean:
	rm -f *.o
	rm -f hello

