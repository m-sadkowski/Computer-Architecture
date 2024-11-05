; Program w asemblerze, w którym nastêpuje konwersja 
; liczby binarnej bez znaku zawartej w rejestrze EAX na ci¹g cyfr dziesiêtnych tej liczby.
; Uzyskiwane cyfry s¹ przekszta³cane na kod ASCII, a nastêpnie wyœwietlane na ekranie. W
; trakcie analizy podanego ni¿ej kodu nale¿y braæ pod uwagê maksymaln¹ zawartoœæ rejestru
; EAX, która mo¿e wynosiæ 232^(-1) = 4 294 967 295 (10 cyfr dziesiêtnych).

.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC 
extern __write : PROC
public _main

.data
	; deklaracja tablicy 12-bajtowej do przechowywania
	; tworzonych cyfr
	znaki db 12 dup (?)

.code
	_main PROC

		mov eax, 1234 ; liczba do konwersji (max 32 bitów, 10 cyfr)

		mov esi, 10 ; indeks w tablicy 'znaki'
		mov ebx, 10 ; dzielnik równy 10

	konwersja:
		mov edx, 0 ; zerowanie starszej czêœci dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX,
		; iloraz w EAX
		add dl, 30H ; zamiana reszty z dzielenia na kod
		; ASCII
		mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
		dec esi ; zmniejszenie indeksu
		cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja ; skok, gdy iloraz niezerowy
		; wype³nienie pozosta³ych bajtów spacjami i wpisanie
		; znaków nowego wiersza

	wypeln:
		or esi, esi
		jz wyswietl ; skok, gdy ESI = 0
		mov byte PTR znaki [esi], 20H ; kod spacji
		dec esi ; zmniejszenie indeksu
		jmp wypeln

	wyswietl:
		mov byte PTR znaki [0], 0AH ; kod nowego wiersza
		mov byte PTR znaki [11], 0AH ; kod nowego wiersza

		; wyœwietlenie cyfr na ekranie
		push dword PTR 12 ; liczba wyœwietlanych znaków
		push dword PTR OFFSET znaki ; adres wyœw. obszaru
		push dword PTR 1; numer urz¹dzenia (ekran ma numer 1)
		call __write ; wyœwietlenie liczby na ekranie
		add esp, 12 ; usuniêcie parametrów ze stosu

		call _ExitProcess@4
	_main ENDP
END