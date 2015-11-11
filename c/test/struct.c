#include <stdio.h>
#include <string.h>

typedef struct {
	char type[1];
	char dir[1];
	int i;
	int j;
	int k;
} sample;

int main(){
	sample s;
	strcpy(s.type, "E");
	strcpy(s.dir, "z");
	s.i = 3;
	s.j = 3;
	s.k = 3;
	if(s.type[0]=='E'){

		printf("\n%c\n",s.type[0]);

	}
}
//printf("\n\n%c %c %d %d %d\n\n",s.type, s.dir, s.i, s.j, s.k);

