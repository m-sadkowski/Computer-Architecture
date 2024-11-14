; Program zawiera wszystkie funkcje do wczytywania i wyswietlania rejestru EAX

.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

public _main

.data
	obszar db 36 dup (?) ; deklaracja tablicy do przechowywania wprowadzanych cyfr
	dziesiec dd 10 ; stała do mnożenia przez 10
	wejscie db 36 dup (?) ; deklaracja tablicy do przechowywania wprowadzanych cyfr

.code
	wyswietl_96bit PROC
		pusha ; zapisanie rejestrów ogólnych

		mov bl, 3 ; liczba rejestrów (3 * 32 bity = 96 bitów)
		mov bh, 10

		push ecx
		push edx

		mov esi, 30 ; indeks w tablicy 'obszar'
		mov edi, 10 ; dzielnik równy 10

	konwersja:
		mov edx, 0 ; zerowanie starszej części dzielnej
		div edi ; dzielenie przez 10, reszta w EDX, iloraz w EAX
		add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
		mov obszar [esi], dl; zapisanie cyfry w kodzie ASCII
		dec esi ; zmniejszenie indeksu
		dec bh
		cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja ; skok, gdy iloraz niezerowy

		cmp bh, 0
		je skip

	dodaj_zera:
		cmp bl, 1
		je skip
		mov byte PTR obszar [esi], 30H ; wpisanie zera
		dec esi ; zmniejszenie indeksu
		dec bh
		jnz dodaj_zera

	skip:
		pop eax
		mov bh, 10
		dec bl
		jnz konwersja
		
		 ; wypełnienie pozostałych bajtów spacjami i wpisanie znaków nowego wiersza
	wypeln:
		or esi, esi ; zamiast cmp esi, 0 ; sprawdzenie czy ESI = 0 jeśli tak to skok
		jz wyswietl ; skok, gdy ESI = 0
		mov byte PTR obszar [esi], 20H ; kod spacji
		dec esi ; zmniejszenie indeksu
		jmp wypeln

	wyswietl:
		mov byte PTR obszar [0], 0AH ; kod nowego wiersza
		mov byte PTR obszar [35], 0AH ; kod nowego wiersza
		; wyświetlenie cyfr na ekranie
		push dword PTR 36 ; liczba wyświetlanych znaków
		push dword PTR OFFSET obszar ; adres wyśw. obszaru
		push dword PTR 1; numer urządzenia (ekran ma numer 1)
		call __write ; wyświetlenie liczby na ekranie
		add esp, 12 ; usunięcie parametrów ze stosu

		popa ; przywrócenie rejestrów ogólnych
		ret ; powrót do miejsca wywołania
	wyswietl_96bit ENDP

	wczytaj_96bit PROC ; edx:ecx:eax rejestr 96 bitowy
		; zapisanie rejestrów ogólnych na stosie
		push ebx
		push esi
		push edi
		push ebp

		mov eax, 0
		mov ecx, 0
		mov edx, 0

		; max ilość znaków wczytywanej liczby
		push dword PTR 30
		push dword PTR OFFSET wejscie ; adres obszaru pamięci
		push dword PTR 0; numer urządzenia (0 dla klawiatury)
		call __read ; odczytywanie znaków z klawiatury
		; (dwa znaki podkreślenia przed read)
		add esp, 12 ; usunięcie parametrów ze stosu
		; bieżąca wartość przekształcanej liczby przechowywana jest
		; w rejestrze EAX; przyjmujemy 0 jako wartość początkową
		mov edi, OFFSET obszar ; adres obszaru ze znakami

	pobieraj_znaki:
		mov bl, [edi] ; pobranie kolejnej cyfry w kodzie ASCII
		inc edi ; zwiększenie indeksu
		cmp bl,10 ; sprawdzenie czy naciśnięto Enter
		je byl_enter ; skok, gdy naciśnięto Enter
		sub bl, 30H ; zamiana kodu ASCII na wartość cyfry
		movzx ebx, bl ; przechowanie wartości cyfry w
		; rejestrze EBX
		; mnożenie wcześniej obliczonej wartości razy 10
		mul dword PTR dziesiec
		add eax, ebx ; dodanie ostatnio odczytanej cyfry
		jmp pobieraj_znaki ; skok na początek pętli

	byl_enter:

		pop ebp
		pop edi
		pop esi
		pop ebx
		ret ; powrót do miejsca wywołania
	wczytaj_96bit ENDP

	_main PROC
		mov ecx, 555
		mov edx, 0FFFFFFFFh
		mov eax, 444
		call wyswietl_96bit

		;call wczytaj_96bit

		push 0
		call _ExitProcess@4
	_main ENDP

END
