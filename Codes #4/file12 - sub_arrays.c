#include <stdio.h>

long long* roznica(long long* odjemne, long long* odjemniki, unsigned int n);

int main()
{
	long long odjemne[] = { 5, 4, 3, 2, 1 };
	long long odjemniki[] = { 1, 2, 3, 4, 5 };
	unsigned int n = 5;
	long long* wynik = roznica(odjemne, odjemniki, n);
	for (int i = 0; i < n; i++)
	{
		printf("%lld\n", wynik[i]);
	}
	free(wynik);
	return 0;
}

/* Napisa� podprogram w asemblerze przystosowany do wywo�ania z poziomu j�zyka C.
Prototyp funkcji implementowanej przez ten program ma posta�: wchar_t* convert_to_string(long long*, long long);
Podprogram powinien zwr�ci� �a�cuch znak�w reprezentuj�cy dwie liczby 64-bitowe przekazane jako parametr.
�a�cuch powinien reprezentowa� liczb� w formacie binarnym, za� znaki zapisane s� w UTF-16.
Napisa� kr�tki program w j�zyku C ilustruj�cy spos�b wywo�ania tego podprogramu.
1. Rezerwacj� tablicy nale�y utworzy� poprzez przydzielenie odpowiedniego obszaru pami�ci za pomoc� funkcji malloc.
2. Nale�y pami�ta� o zwolnieniu przydzielonej pami�ci po wy�wietleniu za pomoc� free.
*/