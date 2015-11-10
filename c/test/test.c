#include <stdio.h>
#include <math.h>

void func(int * a, int * b){
	*a=*a**b;
}




int main(){
	int var1 = 10;
	int var2 = 5;
	printf("var1: %d\nvar2: %d\n",var1,var2);
	printf("Running function...\n");
	func(&var1,&var2);
	printf("var1: %d\nvar2: %d\n",var1,var2);
	return 0;
}

