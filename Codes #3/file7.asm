; zad 3.4
; Napisać program w asemblerze, który wczyta liczbę dziesiętną z klawiatury i
; wyświetli na ekranie jej reprezentację w systemie szesnastkowym
; Zmodyfikować podprogram wyswietl_EAX_hex w taki sposób, by w
; wyświetlanej liczbie szesnastkowej zera nieznaczące z lewej strony zostały zastąpione spacjami.


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
	wyswietl_EAX_hex PROC
		; wyświetlanie zawartości rejestru EAX
		; w postaci liczby szesnastkowej
		pusha ; przechowanie rejestrów

		; rezerwacja 12 bajtów na stosie (poprzez zmniejszenie
		; rejestru ESP) przeznaczonych na tymczasowe przechowanie
		; cyfr szesnastkowych wyświetlanej liczby
		sub esp, 12
		mov edi, esp ; adres zarezerwowanego obszaru
		; pamięci
		; przygotowanie konwersji
		mov ecx, 8 ; liczba obiegów pętli konwersji
		mov esi, 1 ; indeks początkowy używany przy
		; zapisie cyfr
		; pętla konwersji
		ptl3hex:
		; przesunięcie cykliczne (obrót) rejestru EAX o 4 bity w lewo
		; w szczególności, w pierwszym obiegu pętli bity nr 31 - 28
		; rejestru EAX zostaną przesunięte na pozycje 3 - 0
		rol eax, 4
		; wyodrębnienie 4 najmłodszych bitów i odczytanie z tablicy
		; 'dekoder' odpowiadającej im cyfry w zapisie szesnastkowym
		mov ebx, eax ; kopiowanie EAX do EBX
		and ebx, 0000000FH ; zerowanie bitów 31 - 4 rej.EBX

		mov dl, dekoder[ebx] ; pobranie cyfry z tablicy
		; przesłanie cyfry do obszaru roboczego
		mov [edi][esi], dl
		inc esi ;inkrementacja modyfikatora
		loop ptl3hex ; sterowanie pętlą

		; wpisanie znaku nowego wiersza przed i po cyfrach
		mov byte PTR [edi][0], 10
		mov byte PTR [edi][9], 10

		; zamiana zer na spacje
		mov ecx, 10 ; liczba obiegów pętli
		mov esi, 1 ; indeks początkowy
	ptlzera:
		cmp byte PTR [edi][esi], 30H ; sprawdzenie czy cyfra to 0
		je byl_zero ; skok, gdy napotkano 0
		jmp koniec_zer
	byl_zero:
		mov byte PTR [edi][esi], 20H ; zamiana 0 na spację
		inc esi ; inkrementacja indeksu
		loop ptlzera ; sterowanie pętlą
	koniec_zer:

		; wyświetlenie przygotowanych cyfr
		push 10 ; 8 cyfr + 2 znaki nowego wiersza
		push edi ; adres obszaru roboczego
		push 1 ; nr urządzenia (tu: ekran)
		call __write ; wyświetlenie
		; usunięcie ze stosu 24 bajtów, w tym 12 bajtów zapisanych
		; przez 3 rozkazy push przed rozkazem call
		; i 12 bajtów zarezerwowanych na początku podprogramu
		add esp, 24

		popa ; odtworzenie rejestrów
		ret ; powrót z podprogramu
	wyswietl_EAX_hex ENDP


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
		call wyswietl_EAX_hex

		push 0
		call _ExitProcess@4
	_main ENDP

END

