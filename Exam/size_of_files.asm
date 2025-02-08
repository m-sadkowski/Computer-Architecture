.686
.model flat
public _size_of_files
extern _FindNextFileW@8 : PROC

.data

.code
	_size_of_files PROC
		push ebp
		mov ebp, esp
		sub esp, 512 ; rezerwacja miejsca na zmienne lokalne

		finit
		fldz ; zaladowanie inicjalnego 0 na stos koprocesora

	petla:
		lea eax, [ebp - 512] ; za�aduj adres WIN32_FIND_DATA
		push eax
		mov eax, [ebp + 8] ; za�aduj int handle
		push eax
		call _FindNextFileW@8 ; znajd� kolejny plik
		cmp eax, 0 ; je�eli nie znaleziono kolejnego pliku, zakoncz
		je koniec

		; sprawdzenie czy plik to katalog
		mov eax, [ebp - 512] ; pobranie do eax DWORD dwFileAttributes
		bt eax, 4 ; sprawdzenie czy 4 bit jest ustawiony
		jc katalog ; je�li tak, to katalog, nie liczymy go

		; pobranie 64-bitowego rozmiaru pliku
        mov eax, [ebp - 512 + 32] ; pobranie do eax DWORD nFileSizeLow
        mov edx, [ebp - 512 + 28] ; pobranie do edx DWORD nFileSizeHigh
        push edx
        push eax

		 ; za�adowanie na stos koprocesora rozmiaru bie��cego pliku i dodanie go do sumy
        fild qword ptr [esp]
		faddp
		add esp, 8 ; usuni�cie rozmiaru (liczba 64-bitowa) ze stosu

	katalog:
		jmp petla

	koniec:
		mov esp, ebp ; przywr�cenie esp
		pop ebp
		ret
	_size_of_files ENDP
END


