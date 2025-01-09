#include <stdio.h>

char* komunikat(char* tekst);

int main() {
	char* tekst1 = "To jest moj tekst.";
	int dlugosc = 18;
	char* tekst2 = komunikat(tekst1);
	for (int i = 0; i < (dlugosc + 5); i++) {
		printf("%c", *(tekst2 + i));
	}
	return 0;
}