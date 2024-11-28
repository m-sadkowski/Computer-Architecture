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

/* Napisa� podprogram w asemblerze przystosowany do wywo�ania z poziomu j�zyka C. Prototyp funkcji implementowanej przez
ten podprogram ma posta�: unsigned int* convert_to_array(char* tekst);
Podprogram powinien zwr�ci� tablic� liczb 32-bitowych, kt�re zosta�y przekazane do funkcji w formacie �a�cucha znak�w ASCIIZ (max 255 znak�w). 
Przyk�adowo dla �a�cucha "1 3 45 6" powinna zosta� zwr�cona czteroelementowa tablica.
Napisa� kr�tki program w j�zyku C ilustruj�cy spos�b wywo�ania tego podprogramu. 
1. Rezerwacj� tablicy nale�y utworzy� poprzez przydzielenie odpowiedniego obszaru pami�ci przy pomocy funkcji malloc.
2. Nale�y pami�ta� o zwolnieniu pami�ci po zako�czeniu pracy z tablic� przy pomocy funkcji free. 
3. Zak�adamy, �e �a�cuch zostanie wprowadzony zgodnie z formatem, tzn. liczby oddzielone s� spacjami. 
4. Do wczytania �a�cucha u�y� scanf w postaci scanf("%255[^\n]", str1). */