#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>

int* tablica_nieparzystych(int tablica[], unsigned int* n);

int main() {
	int* tablica;
	int n = 10;
	int tab[10] = { 1,2,3,4,5,6,7,8,9,10 };
	tablica = tablica_nieparzystych(tab, &n);
	if (tablica == 0) {
		printf("Nie ma liczb nieparzystych w tablicy\n");
	}
	else {
		for (int i = 0; i < 5; i++) {
			printf("%d ", tablica[i]);
		}
	}
	return 0;
}

/* Napisaæ podprogram w asemblerze przystosowany do wywo³ania z poziomu jêzyka C. Prototyp funkcji implementowanej przez
ten podprogram ma postaæ: int* tablica_nieparzystych(int tablica[], unsigned int* n);
Podprogram ma wydobyæ z tablicy tablica liczby nieparzyste. W tym celu tworzy dynamicznie now¹ tablicê o wymaganych rozmiarach (tzn. takich, aby zmieœci³y siê
tam wszystkie liczby nieparzyste z tablicy) i zwraca adres nowej tablicy (albo 0, jeœli tablicy nie mo¿na by³o utworzyæ lub nie ma liczb nieparzystych).
n oznacza liczbê elementów w tablicy Ÿród³owej, zaœ jako wynik wpisujemy w to miejsce liczbê znalezionych elementów nieparzystych.
Napisaæ krótki program w jêzyku C ilustruj¹cy sposób wywo³ania tego podprogramu. 
1. Now¹ tablicê nale¿y utworzyæ poprzez przydzielenie odpowiedniego obszaru pamiêci przy pomocy funkcji malloc.
2. Funkcja biblioteczna jêzyka C o prototypie void * malloc(unsigned int k); przydziela k-bajtowy obszar pamiêci i zwraca adres przydzielonego obszaru.
   Jeœli wymagany obszar nie mo¿e byæ przydzielony, to funkcja zwraca wartoœæ 0.
3. Sprawdzenie czy liczba jest nieparzysta naj³atwiej jest wykonaæ poprzez odczytanie najm³odszego bitu liczby (bit nr 0) */