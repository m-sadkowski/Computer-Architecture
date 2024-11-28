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

/* Napisa� podprogram w asemblerze przystosowany do wywo�ania z poziomu j�zyka C. Prototyp funkcji implementowanej przez
ten podprogram ma posta�: int* tablica_nieparzystych(int tablica[], unsigned int* n);
Podprogram ma wydoby� z tablicy tablica liczby nieparzyste. W tym celu tworzy dynamicznie now� tablic� o wymaganych rozmiarach (tzn. takich, aby zmie�ci�y si�
tam wszystkie liczby nieparzyste z tablicy) i zwraca adres nowej tablicy (albo 0, je�li tablicy nie mo�na by�o utworzy� lub nie ma liczb nieparzystych).
n oznacza liczb� element�w w tablicy �r�d�owej, za� jako wynik wpisujemy w to miejsce liczb� znalezionych element�w nieparzystych.
Napisa� kr�tki program w j�zyku C ilustruj�cy spos�b wywo�ania tego podprogramu. 
1. Now� tablic� nale�y utworzy� poprzez przydzielenie odpowiedniego obszaru pami�ci przy pomocy funkcji malloc.
2. Funkcja biblioteczna j�zyka C o prototypie void * malloc(unsigned int k); przydziela k-bajtowy obszar pami�ci i zwraca adres przydzielonego obszaru.
   Je�li wymagany obszar nie mo�e by� przydzielony, to funkcja zwraca warto�� 0.
3. Sprawdzenie czy liczba jest nieparzysta naj�atwiej jest wykona� poprzez odczytanie najm�odszego bitu liczby (bit nr 0) */