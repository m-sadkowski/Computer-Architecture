; Napisa� program w asemblerze, kt�ry wy�wietli na ekranie 50 pocz�tkowych element�w ci�gu liczb: 1, 2, 4, 7, 11, 16, 22, ... 

.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC

public _main

.data
	znaki db 12 dup (?)

.code
	wyswietl_EAX PROC
		pusha ; zapisanie rejestr�w og�lnych

		mov esi, 10 ; indeks w tablicy 'znaki'
		mov ebx, 10 ; dzielnik r�wny 10

	konwersja:
		mov edx, 0 ; zerowanie starszej cz�ci dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
		add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
		mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
		dec esi ; zmniejszenie indeksu
		cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja ; skok, gdy iloraz niezerowy
		
		 ; wype�nienie pozosta�ych bajt�w spacjami i wpisanie znak�w nowego wiersza
	wypeln:
		or esi, esi
		jz wyswietl ; skok, gdy ESI = 0
		mov byte PTR znaki [esi], 20H ; kod spacji
		dec esi ; zmniejszenie indeksu
		jmp wypeln

	wyswietl:
		mov byte PTR znaki [0], 0AH ; kod nowego wiersza
		mov byte PTR znaki [11], 0AH ; kod nowego wiersza
		; wy�wietlenie cyfr na ekranie
		push dword PTR 12 ; liczba wy�wietlanych znak�w
		push dword PTR OFFSET znaki ; adres wy�w. obszaru
		push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
		call __write ; wy�wietlenie liczby na ekranie
		add esp, 12 ; usuni�cie parametr�w ze stosu

		popa ; przywr�cenie rejestr�w og�lnych
		ret ; powr�t do miejsca wywo�ania
	wyswietl_EAX ENDP

	_main PROC
		mov eax, 1
		mov ebx, 0
		mov esi, 50

	ptl:
		add eax, ebx
		call wyswietl_EAX
		inc ebx
		dec esi
		cmp esi, 0
		jne ptl
		

		push 0
		call _ExitProcess@4
	_main ENDP

END