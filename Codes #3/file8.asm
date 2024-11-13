; Wczytuje liczbę 16-tkową i wypisuje liczbę 16-tkową


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
		call wyswietl_EAX_hex

		push 0
		call _ExitProcess@4
	_main ENDP

END

