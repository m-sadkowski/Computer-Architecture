.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
extern _MessageBoxA@16 : PROC
extern __write : PROC ; (dwa znaki podkreúlenia)
extern __read : PROC ; (dwa znaki podkreúlenia)
public _main

.data
	tekst_pocz db 10, 'Prosze napisac jakis tekst '
	db 'i nacisnac Enter', 10
	koniec_t db ?  ; koniec tekstu poczatkowego
	magazyn db 80 dup (?) ; bufor na tekst
	magazynW dw 80 dup (?) ; bufor na przekszta≥cony tekst
	nowa_linia db 10  ; znak nowej linii
	liczba_znakow dd ?  ; liczba znakow wczytanych
	tytul db 10, 'MessageBoxA (UTF-8)', 0 ; tytul MessageBoxa
	tytulW dw 10, 'M', 'e', 's', 's', 'a', 'g', 'e', 'B', 'o', 'x', 'W', ' ', '(', 'U', 'T', 'F', '-', '1', '6', ')', 0 ; tytul MessageBoxa

.code
	_main PROC
		; wyúwietlenie tekstu informacyjnego
		mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
		push ecx
		push OFFSET tekst_pocz ; adres tekstu
		push 1 ; nr urzπdzenia (tu: ekran - nr 1)
		call __write ; wyúwietlenie tekstu poczπtkowego
		add esp, 12 ; usuniecie parametrÛw ze stosu

		; czytanie wiersza z klawiatury
		push 80 ; maksymalna liczba znakÛw
		push OFFSET magazyn
		push 0 ; nr urzπdzenia (tu: klawiatura - nr 0)
		call __read ; czytanie znakÛw z klawiatury
		add esp, 12 ; usuniecie parametrÛw ze stosu

		; liczba znakÛw
		mov liczba_znakow, eax

		; przekszta≥canie wczytanego tekstu na wielkie litery
		mov ecx, eax ; liczba wprowadzonych znakÛw
		mov ebx, 0 ; indeks poczπtkowy

		ptl:
			mov dl, magazyn[ebx] ; pobranie kolejnego znaku

			; Sprawdzanie i konwersja polskich znakÛw diakrytycznych
			cmp dl, 165
			je litera_a  ; π -> •
			cmp dl, 134
			je litera_c  ; Ê -> ∆
			cmp dl, 169
			je litera_e  ; Í ->  
			cmp dl, 136
			je litera_l  ; ≥ -> £
			cmp dl, 228
			je litera_n  ; Ò -> —
			cmp dl, 162
			je litera_o  ; Û -> ”
			cmp dl, 152
			je litera_s  ; ú -> å
			cmp dl, 171
			je litera_z  ; ü -> è
			cmp dl, 190
			je litera_zz ; ø -> Ø

			jmp pomin ; jeúli nie wymaga zmiany

		litera_a:
			mov dl, 0A5h ; kod ANSI dla •
			mov magazyn[ebx], dl
			jmp dalej

		litera_c:
			mov dl, 0C6h ; kod ANSI dla ∆
			mov magazyn[ebx], dl
			jmp dalej

		litera_e:
			mov dl, 0CAh ; kod ANSI dla  
			mov magazyn[ebx], dl
			jmp dalej

		litera_l:
			mov dl, 0A3h ; kod ANSI dla £
			mov magazyn[ebx], dl
			jmp dalej

		litera_n:
			mov dl, 0D1h ; kod ANSI dla —
			mov magazyn[ebx], dl
			jmp dalej

		litera_o:
			mov dl, 0D3h ; kod ANSI dla ”
			mov magazyn[ebx], dl
			jmp dalej

		litera_s:
			mov dl, 08Ch ; kod ANSI dla å
			mov magazyn[ebx], dl
			jmp dalej

		litera_z:
			mov dl, 08Fh ; kod ANSI dla è
			mov magazyn[ebx], dl
			jmp dalej

		litera_zz:
			mov dl, 0AFh ; kod ANSI dla Ø
			mov magazyn[ebx], dl
			jmp dalej

		pomin:
			; zamiana na wielkie litery dla zwyk≥ych liter alfabetu
			cmp dl, 'a'
			jb dalej ; jeúli mniejsza niø 'a', pomin
			cmp dl, 'z'
			ja dalej ; jeúli wiÍksza niø 'z', pomin

			sub dl, 20H ; zamiana na wielkie litery (dla liter a-z)
			mov magazyn[ebx], dl ; zapisanie zmienionego znaku

		dalej:
			inc ebx
			dec ecx
			jnz ptl

		; konwersja magazyn (UTF-8) na magazynW (UTF-16)

		mov esi,0
		mov edi,0
		mov ecx,48

		etykieta2:
			mov al,byte ptr magazyn[esi]
			add esi,1
			cmp al,7fh
			ja znak_wielobajtowy

		movzx ax,al
		mov word ptr magazynW[edi],ax
		add edi,2
		jmp  koniec

		znak_wielobajtowy:
			; obsluga znakÛw wielobajtowych
			bt eax,5
			jc znak_utf8_3_lub_4bajtowy
			; znak jest dwubajtowy
			shl ax,8
			mov al,magazyn[esi]
			inc esi
			shl al,2
			shl ax,3
			shr ax,5
			mov word ptr magazynW[edi],ax
			add edi,2
			sub ecx,1
			jmp  koniec

		znak_utf8_3_lub_4bajtowy:
			bt eax,4
			jc znak_4bajtowy
			; znak jest trzybajtowy
			shl ax,8
			mov al,magazyn[esi]
			inc esi
			shl al,2
			shl eax,6
			mov al,magazyn[esi]
			inc esi
			shl al,2
			shr eax,2
			mov word ptr magazynW[edi],ax
			add edi,2
			sub ecx,2
			jmp  koniec

		znak_4bajtowy:
		; znak jest trzybajtowy
			shl ax,8
			mov al,magazyn[esi]
			inc esi
			shl al,2
			shl eax,6
			mov al,magazyn[esi]
			inc esi
			shl al,2
			shl eax,6
			mov al,magazyn[esi]
			inc esi
			shl al,2
			shl eax,9
			shr eax,11		
			sub eax,10000H  ; punkt kodowy w eax =  0000 0000 0000 xxxx xxxx xx yyyy yyyy yy
			mov ebx,eax
			shr ebx,10   ; ebx 0000000 . 000 000 xxxx xxxx xx
			add ebx, 1101100000000000b
			;  000000xxxxxxxxxxb
			shl ax,6
			shr ax,6   ; ax = 0000000yyyyyyyyyy
			add ax,1101110000000000b
			;xchg bh,bl
			mov word ptr magazynW[edi],bx
			add edi,2
			;xchg al,ah
			mov word ptr magazynW[edi],ax
			add edi,2
			sub ecx,3
			jmp  koniec

		koniec:	
			sub ecx,1
			jnz etykieta2

		; wyúwietlenie przekszta≥conego tekstu za pomocπ MessageBoxA
		push 4 ; uchwyt okna nadrzÍdnego
		push OFFSET tytulW ; tytu≥
		push OFFSET magazynW ; przekszta≥cony tekst
		push 0 ; rodzaj ikony
		call _MessageBoxW@16 ; wyúwietlenie okna MessageBoxW
		add esp, 16 ; usuniÍcie parametrÛw

		push 0 ; uchwyt okna nadrzÍdnego
		push OFFSET tytul ; tytu≥
		push OFFSET magazyn ; przekszta≥cony tekst
		push 0 ; rodzaj ikony
		call _MessageBoxA@16 ; wyúwietlenie okna MessageBoxW
		add esp, 16 ; usuniÍcie parametrÛw

		; zakoÒczenie programu
		call _ExitProcess@4
	_main ENDP
END
