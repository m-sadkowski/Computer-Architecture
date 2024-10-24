; wczytywanie i wy�wietlanie tekstu wielkimi literami
; (inne znaki si� nie zmieniaj�)
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC
extern __write : PROC ; (dwa znaki podkre�lenia)
extern __read : PROC ; (dwa znaki podkre�lenia)
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
	; wy�wietlenie tekstu informacyjnego
	; liczba znak�w tekstu
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
		push ecx
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urz�dzenia (tu: ekran - nr 1)
		call __write ; wy�wietlenie tekstu pocz�tkowego
		add esp, 12 ; usuniecie parametr�w ze stosu
		; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znak�w
		push OFFSET magazyn
		push 0 ; nr urz�dzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znak�w z klawiatury
		add esp, 12 ; usuniecie parametr�w ze stosu
		; kody ASCII napisanego tekstu zosta�y wprowadzone
		; do obszaru 'magazyn'
		; funkcja read wpisuje do rejestru EAX liczb�
		; wprowadzonych znak�w
		mov liczba_znakow, eax
		; rejestr ECX pe�ni rol� licznika obieg�w p�tli
		mov ecx, eax
		mov ebx, 0 ; indeks pocz�tkowy
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
		jmp dalej ; skok do ko�ca p�tli

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

		; odes�anie znaku do pami�ci
		mov magazyn[ebx], dl

		dalej: inc ebx
		dec ecx
		jnz ptl

		jmp koniec

		koniec:
		; wy�wietlenie przekszta�conego tekstu
		push liczba_znakow
		push OFFSET magazyn
		push 1
		call __write ; wy�wietlenie przekszta�conego
		add esp, 12 ; usuniecie parametr�w ze stosu
		push 0
		call _ExitProcess@4 ; zako�czenie programu
	_main ENDP
END
