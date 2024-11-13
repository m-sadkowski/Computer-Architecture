; Wczytuje liczbę 16-tkową i wypisuje liczbę dziesiętną


.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

public _main

.data
	; deklaracja tablicy do przechowywania wprowadzanych cyfr
	obszar db 12 dup (?)
	dziesiec dd 10 ; mnożnik
	dekoder db '0123456789ABCDEF' ; tablica do konwersji na postać szesnastkową

.code
	wyswietl_EAX PROC
		pusha ; zapisanie rejestrów ogólnych

		mov esi, 10 ; indeks w tablicy 'znaki'
		mov ebx, 10 ; dzielnik równy 10

	konwersja:
		mov edx, 0 ; zerowanie starszej części dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
		add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
		mov obszar [esi], dl; zapisanie cyfry w kodzie ASCII
		dec esi ; zmniejszenie indeksu
		cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja ; skok, gdy iloraz niezerowy
		
		 ; wypełnienie pozostałych bajtów spacjami i wpisanie znaków nowego wiersza
	wypeln:
		or esi, esi
		jz wyswietl ; skok, gdy ESI = 0
		mov byte PTR obszar [esi], 20H ; kod spacji
		dec esi ; zmniejszenie indeksu
		jmp wypeln

	wyswietl:
		mov byte PTR obszar [0], 0AH ; kod nowego wiersza
		mov byte PTR obszar [11], 0AH ; kod nowego wiersza
		; wyświetlenie cyfr na ekranie
		push dword PTR 12 ; liczba wyświetlanych znaków
		push dword PTR OFFSET obszar ; adres wyśw. obszaru
		push dword PTR 1; numer urządzenia (ekran ma numer 1)
		call __write ; wyświetlenie liczby na ekranie
		add esp, 12 ; usunięcie parametrów ze stosu

		popa ; przywrócenie rejestrów ogólnych
		ret ; powrót do miejsca wywołania
	wyswietl_EAX ENDP


	wczytaj_do_EAX_hex PROC
		; wczytywanie liczby szesnastkowej z klawiatury – liczba po
		; konwersji na postać binarną zostaje wpisana do rejestru EAX
		; po wprowadzeniu ostatniej cyfry należy nacisnąć klawisz
		; Enter
		push ebx
		push ecx
		push edx
		push esi
		push edi
		push ebp
		; rezerwacja 12 bajtów na stosie przeznaczonych na tymczasowe
		; przechowanie cyfr szesnastkowych wyświetlanej liczby
		sub esp, 12 ; rezerwacja poprzez zmniejszenie ESP
		mov esi, esp ; adres zarezerwowanego obszaru pamięci
		push dword PTR 10 ; max ilość znaków wczytyw. liczby
		push esi ; adres obszaru pamięci
		push dword PTR 0; numer urządzenia (0 dla klawiatury)
		call __read ; odczytywanie znaków z klawiatury
		; (dwa znaki podkreślenia przed read)
		add esp, 12 ; usunięcie parametrów ze stosu
		mov eax, 0 ; dotychczas uzyskany wynik
	pocz_konw:
		mov dl, [esi] ; pobranie kolejnego bajtu
		inc esi ; inkrementacja indeksu
		cmp dl, 10 ; sprawdzenie czy naciśnięto Enter
		je gotowe ; skok do końca podprogramu
		; sprawdzenie czy wprowadzony znak jest cyfrą 0, 1, 2 , ..., 9
		cmp dl, '0'
		jb pocz_konw ; inny znak jest ignorowany
		cmp dl, '9'
		ja sprawdzaj_dalej
		sub dl, '0' ; zamiana kodu ASCII na wartość cyfry
	dopisz:
		shl eax, 4 ; przesunięcie logiczne w lewo o 4 bity
		or al, dl ; dopisanie utworzonego kodu 4-bitowego
		; na 4 ostatnie bity rejestru EAX
		jmp pocz_konw ; skok na początek pętli konwersji
		; sprawdzenie czy wprowadzony znak jest cyfrą A, B, ..., F
	sprawdzaj_dalej:
		cmp dl, 'A'
		jb pocz_konw ; inny znak jest ignorowany
		cmp dl, 'F'
		ja sprawdzaj_dalej2
		sub dl, 'A' - 10 ; wyznaczenie kodu binarnego
		jmp dopisz

	; sprawdzenie czy wprowadzony znak jest cyfrą a, b, ..., f
	sprawdzaj_dalej2:
		cmp dl, 'a'
		jb pocz_konw ; inny znak jest ignorowany
		cmp dl, 'f'
		ja pocz_konw ; inny znak jest ignorowany
		sub dl, 'a' - 10
		jmp dopisz

	gotowe:
	; zwolnienie zarezerwowanego obszaru pamięci
		add esp, 12
		pop ebp
		pop edi
		pop esi
		pop edx
		pop ecx
		pop ebx
		ret
	wczytaj_do_EAX_hex ENDP

	_main PROC
		 ;wywołanie procedury wczytaj_do_EAX_hex
		call wczytaj_do_EAX_hex
		;wywołanie procedury wyswietl_EAX_hex
		call wyswietl_EAX

		push 0
		call _ExitProcess@4
	_main ENDP

END

