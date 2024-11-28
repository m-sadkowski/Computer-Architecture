#include <stdio.h>

wchar_t* convert_to_string(long long*, long long);

int main()
{
	long long a = 0x0111111000000000;
	long long b = 0x1000000111111111;
	wchar_t* result = convert_to_string(&a, b);
	wprintf(L"%ls\n", result); // ma wypisa� �a�cuch znak�w reprezentuj�cy liczby a i b w formacie binarnym
	free(result);
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