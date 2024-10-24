; wczytywanie i wyœwietlanie tekstu wielkimi literami
; (inne znaki siê nie zmieniaj¹)
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern __write : PROC ; (dwa znaki podkreœlenia)
extern __read : PROC ; (dwa znaki podkreœlenia)
public _main

.data
	tekst_pocz db 10, 'Prosze napisac jakis tekst '
	db 'i nacisnac Enter', 10
	koniec_t db ?
	magazyn db 80 dup (?)
	nowa_linia db 10
	liczba_znakow dd ?

.code
	_main PROC
	; wyœwietlenie tekstu informacyjnego
	; liczba znaków tekstu
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
		push ecx
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urz¹dzenia (tu: ekran - nr 1)
		call __write ; wyœwietlenie tekstu pocz¹tkowego
		add esp, 12 ; usuniecie parametrów ze stosu
		; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znaków
		push OFFSET magazyn
		push 0 ; nr urz¹dzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znaków z klawiatury
		add esp, 12 ; usuniecie parametrów ze stosu
		; kody ASCII napisanego tekstu zosta³y wprowadzone
		; do obszaru 'magazyn'
		; funkcja read wpisuje do rejestru EAX liczbê
		; wprowadzonych znaków
		mov liczba_znakow, eax
		; rejestr ECX pe³ni rolê licznika obiegów pêtli
		mov ecx, eax
		mov ebx, 0 ; indeks pocz¹tkowy
		ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku

		cmp dl, 165
		je litera_a ; skok, gdy znak polski
		cmp dl, 134
		je litera_c ; skok, gdy znak polski
		cmp dl, 169	
		je litera_e ; skok, gdy znak polski
		cmp dl, 136
		je litera_l ; skok, gdy znak polski
		cmp dl, 228
		je litera_n ; skok, gdy znak polski
		cmp dl, 162
		je litera_o ; skok, gdy znak polski
		cmp dl, 152
		je litera_s ; skok, gdy znak polski
		cmp dl, 171
		je litera_z ; skok, gdy znak polski 
		cmp dl, 190
		je litera_zz ; skok, gdy znak polski 

		jmp pomin ; skok, gdy znak nie wymaga zamiany

		litera_a: sub dl, 1
		mov magazyn[ebx], dl ; zapisanie zmienionego znaku
		jmp dalej ; skok do koñca pêtli

		litera_c: add dl, 9
		mov magazyn[ebx], dl 
		jmp dalej 

		litera_e: sub dl, 1
		mov magazyn[ebx], dl
		jmp dalej

		litera_l: add dl, 21
		mov magazyn[ebx], dl
		jmp dalej

		litera_n: sub dl, 1
		mov magazyn[ebx], dl
		jmp dalej

		litera_o: add dl, 62
		mov magazyn[ebx], dl
		jmp dalej

		litera_s: sub dl, 1
		mov magazyn[ebx], dl
		jmp dalej

		litera_z: sub dl, 30
		mov magazyn[ebx], dl
		jmp dalej

		litera_zz: sub dl, 1
		mov magazyn[ebx], dl
		jmp dalej

		pomin:
		cmp dl, 'a'
		jb dalej ; skok, gdy znak nie wymaga zamiany
		cmp dl, 'z'
		ja dalej ; skok, gdy znak nie wymaga zamiany

		sub dl, 20H ; zamiana na wielkie litery

		; odes³anie znaku do pamiêci
		mov magazyn[ebx], dl

		dalej: inc ebx
		dec ecx
		jnz ptl

		jmp koniec

		koniec:
		; wyœwietlenie przekszta³conego tekstu
		push liczba_znakow
		push OFFSET magazyn
		push 1
		call __write ; wyœwietlenie przekszta³conego
		add esp, 12 ; usuniecie parametrów ze stosu
		push 0
		call _ExitProcess@4 ; zakoñczenie programu
	_main ENDP
END
