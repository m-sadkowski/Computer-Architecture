#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

unsigned int* convert_to_array(char* tekst);

int main() {
	char str1[255];
	scanf("%255[^\n]", str1);

	unsigned int* tab = convert_to_array(str1);
	int suma = 0;

	for (int i = 0; i < 5; i++) {
		printf("\n%d", tab[i]);
		suma += tab[i];
	}
	printf("\n%d", suma);
	
	free(tab);

}

/* Napisaæ podprogram w asemblerze przystosowany do wywo³ania z poziomu jêzyka C. Prototyp funkcji implementowanej przez
ten podprogram ma postaæ: unsigned int* convert_to_array(char* tekst);
Podprogram powinien zwróciæ tablicê liczb 32-bitowych, które zosta³y przekazane do funkcji w formacie ³añcucha znaków ASCIIZ (max 255 znaków). 
Przyk³adowo dla ³añcucha "1 3 45 6" powinna zostaæ zwrócona czteroelementowa tablica.
Napisaæ krótki program w jêzyku C ilustruj¹cy sposób wywo³ania tego podprogramu. 
1. Rezerwacjê tablicy nale¿y utworzyæ poprzez przydzielenie odpowiedniego obszaru pamiêci przy pomocy funkcji malloc.
2. Nale¿y pamiêtaæ o zwolnieniu pamiêci po zakoñczeniu pracy z tablic¹ przy pomocy funkcji free. 
3. Zak³adamy, ¿e ³añcuch zostanie wprowadzony zgodnie z formatem, tzn. liczby oddzielone s¹ spacjami. 
4. Do wczytania ³añcucha u¿yæ scanf w postaci scanf("%255[^\n]", str1). */