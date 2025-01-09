#include <stdio.h>

void szyfruj(char* tekst);

int main() {
	char napis[] = "Jebac AKO";
	szyfruj(napis);
	for (int i = 0; i < 9; i++) {
		printf("%c", napis[i]);
	}
}