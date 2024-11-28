#include <stdio.h>

void sort(int tabl[], int n);

int main()
{
	int n = 10; 
	int tabl[] = { -1, 1, 0, -6, 5, 215, 7, 18, 0, -6 };
	sort(tabl, n);
	for (int i = 0; i < n; i++)
	{
		printf("%d ", tabl[i]);
	}
	
	return 0;
}
