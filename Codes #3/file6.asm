; zad 3.2
; wczytywanie liczby dziesiętnej z klawiatury – po
; wprowadzeniu cyfr należy nacisnąć klawisz Enter
; liczba po konwersji na postać binarną zostaje wpisana
; do rejestru EAX

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
	znaki db 12 dup (?) ; tablica do przechowywania znaków ASCII

.code
	wyswietl_EAX PROC
		pusha ; zapisanie rejestrów ogólnych

		mov esi, 10 ; indeks w tablicy 'znaki'
		mov ebx, 10 ; dzielnik równy 10

	konwersja:
		mov edx, 0 ; zerowanie starszej części dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
		add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
		mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
		dec esi ; zmniejszenie indeksu
		cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja ; skok, gdy iloraz niezerowy
		
		 ; wypełnienie pozostałych bajtów spacjami i wpisanie znaków nowego wiersza
	wypeln:
		or esi, esi
		jz wyswietl ; skok, gdy ESI = 0
		mov byte PTR znaki [esi], 20H ; kod spacji
		dec esi ; zmniejszenie indeksu
		jmp wypeln

	wyswietl:
		mov byte PTR znaki [0], 0AH ; kod nowego wiersza
		mov byte PTR znaki [11], 0AH ; kod nowego wiersza
		; wyświetlenie cyfr na ekranie
		push dword PTR 12 ; liczba wyświetlanych znaków
		push dword PTR OFFSET znaki ; adres wyśw. obszaru
		push dword PTR 1; numer urządzenia (ekran ma numer 1)
		call __write ; wyświetlenie liczby na ekranie
		add esp, 12 ; usunięcie parametrów ze stosu

		popa ; przywrócenie rejestrów ogólnych
		ret ; powrót do miejsca wywołania
	wyswietl_EAX ENDP

	wczytaj_do_EAX PROC
		; zapisanie rejestrów ogólnych na stosie
		push ebx
		push ecx
		push edx
		push esi
		push edi
		push ebp

		; max ilość znaków wczytywanej liczby
		push dword PTR 12
		push dword PTR OFFSET obszar ; adres obszaru pamięci
		push dword PTR 0; numer urządzenia (0 dla klawiatury)
		call __read ; odczytywanie znaków z klawiatury
		; (dwa znaki podkreślenia przed read)
		add esp, 12 ; usunięcie parametrów ze stosu
		; bieżąca wartość przekształcanej liczby przechowywana jest
		; w rejestrze EAX; przyjmujemy 0 jako wartość początkową
		mov eax, 0
		mov ebx, OFFSET obszar ; adres obszaru ze znakami

	pobieraj_znaki:
		mov cl, [ebx] ; pobranie kolejnej cyfry w kodzie
		; ASCII
		inc ebx ; zwiększenie indeksu
		cmp cl,10 ; sprawdzenie czy naciśnięto Enter
		je byl_enter ; skok, gdy naciśnięto Enter
		sub cl, 30H ; zamiana kodu ASCII na wartość cyfry
		movzx ecx, cl ; przechowanie wartości cyfry w
		; rejestrze ECX
		; mnożenie wcześniej obliczonej wartości razy 10
		mul dword PTR dziesiec
		add eax, ecx ; dodanie ostatnio odczytanej cyfry
		jmp pobieraj_znaki ; skok na początek pętli

	byl_enter:

		pop ebp
		pop edi
		pop esi
		pop edx
		pop ecx
		pop ebx
		ret ; powrót do miejsca wywołania
	wczytaj_do_EAX ENDP

	_main PROC
		 ;wywołanie procedury wczytaj_doEAX
		call wczytaj_do_EAX
		;wywołanie procedury wyswietl_EAX
		mul EAX
		call wyswietl_EAX

		push 0
		call _ExitProcess@4
	_main ENDP

END



; Program ten wczytuje liczbę dziesiętną z klawiatury, konwertuje ją na reprezentację binarną i zapisuje wynik w rejestrze EAX, 
; aby następnie wyświetlić jego kwadrat na ekranie. Proces ten składa się z kilku kroków:
;	1) Wczytanie liczby dziesiętnej z klawiatury:
;		Podprogram wczytaj_do_EAX odczytuje znaki wprowadzone z klawiatury, które reprezentują cyfry liczby dziesiętnej (zapisane w kodzie ASCII).
;		Dla każdej cyfry, kod ASCII jest konwertowany na wartość dziesiętną przez odjęcie wartości 30H (ASCII dla '0').
;		Następnie, bieżąca wartość w rejestrze EAX (gdzie budowana jest liczba) jest mnożona przez 10, po czym dodawana jest nowa cyfra. 
;		W ten sposób liczba jest budowana iteracyjnie na zasadzie: (((0⋅10+5)⋅10+8)⋅10+0)⋅10+4
;		Proces kończy się po naciśnięciu klawisza Enter (który wprowadza kod ASCII 10).
;	2) Wyświetlenie liczby:
;		Podprogram wyswietl_EAX konwertuje wynik w EAX na postać dziesiętną do wyświetlenia, przeprowadzając operacje dzielenia przez 10. Wartości reszt z dzielenia są przekształcane na kod ASCII i zapisywane w tablicy znaki.
;		Liczba w postaci znaków ASCII jest wyświetlana na ekranie przy pomocy funkcji __write.
;	3) Obsługa stosu:
;		Zamiast instrukcji pusha i popa, stosowane są instrukcje push i pop na początku i końcu procedury wczytaj_do_EAX dla odpowiednich rejestrów
;		(oprócz EAX i ESP). Jest to konieczne, ponieważ pusha i popa zapisują wszystkie rejestry, 
;		co może być niepotrzebne i zajmować dodatkową przestrzeń stosu.
;		W skrócie, program wczytuje liczbę dziesiętną, konwertuje ją na wartość binarną (która jest naturalnie obsługiwana przez procesor) 
;		i wyświetla ją na ekranie, umożliwiając konwersję liczb wprowadzanych z klawiatury w czasie rzeczywistym.