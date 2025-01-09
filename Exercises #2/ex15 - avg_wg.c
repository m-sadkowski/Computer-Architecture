#include <stdio.h>

float avg_wd(int n, void * tablica, void * wagi);

int main() {
	float tablica[5] = {1.0, 2.0, 1.0, 2.0, 2.0};
	float wagi[5] = { 3.0, 1.0, 1.0, 3.0, 3.0 };
	int n = 5;
	printf("%f", avg_wd(n, tablica, wagi));
	return 0;
}