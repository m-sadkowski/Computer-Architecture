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

/* Napisaæ podprogram w asemblerze przystosowany do wywo³ania z poziomu jêzyka C.
Prototyp funkcji implementowanej przez ten program ma postaæ: wchar_t* convert_to_string(long long*, long long);
Podprogram powinien zwróciæ ³añcuch znaków reprezentuj¹cy dwie liczby 64-bitowe przekazane jako parametr.
£añcuch powinien reprezentowaæ liczbê w formacie binarnym, zaœ znaki zapisane s¹ w UTF-16.
Napisaæ krótki program w jêzyku C ilustruj¹cy sposób wywo³ania tego podprogramu.
1. Rezerwacjê tablicy nale¿y utworzyæ poprzez przydzielenie odpowiedniego obszaru pamiêci za pomoc¹ funkcji malloc.
2. Nale¿y pamiêtaæ o zwolnieniu przydzielonej pamiêci po wyœwietleniu za pomoc¹ free.
*/