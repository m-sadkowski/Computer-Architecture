; Program w asemblerze, w kt�rym nast�puje konwersja 
; liczby binarnej bez znaku zawartej w rejestrze EAX na ci�g cyfr dziesi�tnych tej liczby.
; Uzyskiwane cyfry s� przekszta�cane na kod ASCII, a nast�pnie wy�wietlane na ekranie. W
; trakcie analizy podanego ni�ej kodu nale�y bra� pod uwag� maksymaln� zawarto�� rejestru
; EAX, kt�ra mo�e wynosi� 232^(-1) = 4 294 967 295 (10 cyfr dziesi�tnych).

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

		mov eax, 1101b ; liczba do konwersji (max 32 bit�w, 10 cyfr)

		mov esi, 10 ; indeks w tablicy 'znaki'
		mov ebx, 10 ; dzielnik r�wny 10

	konwersja:
		mov edx, 0 ; zerowanie starszej cz�ci dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX,
		; iloraz w EAX
		add dl, 30H ; zamiana reszty z dzielenia na kod
		; ASCII
		mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
		dec esi ; zmniejszenie indeksu
		cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja ; skok, gdy iloraz niezerowy
		; wype�nienie pozosta�ych bajt�w spacjami i wpisanie
		; znak�w nowego wiersza

	wypeln:
		or esi, esi ; sprawdzenie czy indeks = 0 (= cmp esi, 0)
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

		call _ExitProcess@4
	_main ENDP
END