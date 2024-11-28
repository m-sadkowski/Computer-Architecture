#include <stdio.h>

wchar_t* convert_to_string(long long*, long long);

int main()
{
	long long a = 0x0111111000000000;
	long long b = 0x1000000111111111;
	wchar_t* result = convert_to_string(&a, b);
	wprintf(L"%ls\n", result); // ma wypisaæ ³añcuch znaków reprezentuj¹cy liczby a i b w formacie binarnym
	free(result);
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