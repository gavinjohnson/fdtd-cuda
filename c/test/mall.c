#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#define arr(i) (*(arr+i))
#define IDX(arr,i) (*(arr+i))


#define N 10

int main(){
	int * arr = malloc(N*sizeof(int));
	int i;
	for (i=0;i<N;i++){
		arr[i] = i;
	}
	for (i=0;i<N;i++){
		printf("arr[i]: %d\n",arr[i]);
	}

	for (i=0;i<N;i++){
		printf("*(arr+i): %d\n",*(arr+i));
	}

	for (i=0;i<N;i++){
		printf("arr(i): %d\n",arr(i));
	}
	for (i=0;i<N;i++){
		printf("IDX(arr,i): %d\n",IDX(arr,i));
	}
	for (i=1;i<N-1;i++){
		printf("IDX(arr,i-1): %d\n",IDX(arr,i-1));
	}


	return 0;
}






