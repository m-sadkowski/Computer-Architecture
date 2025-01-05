.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy
;============================================================
; podprogram 'wyswietl_AL' wy�wietla zawarto�� rejestru AL
; w postaci liczby dziesi�tnej bez znaku
	wyswietl_AL PROC
		; wy�wietlanie zawarto�ci rejestru AL na ekranie wg adresu
		; podanego w ES:BX
		; stosowany jest bezpo�redni zapis do pami�ci ekranu
		; przechowanie rejestr�w
		push ax
		push cx
		push dx
		mov cl, 10 ; dzielnik

		mov ah, 0 ; zerowanie starszej cz�ci dzielnej
		; dzielenie liczby w AX przez liczb� w CL, iloraz w AL,
		; reszta w AH (tu: dzielenie przez 10)
		div cl
		add ah, 30H ; zamiana na kod ASCII
		mov es:[bx+4], ah ; cyfra jedno�ci
		mov ah, 0
		div cl ; drugie dzielenie przez 10
		add ah, 30H ; zamiana na kod ASCII
		mov es:[bx+2], ah ; cyfra dziesi�tek
		add al, 30H ; zamiana na kod ASCII
		mov es:[bx+0], al ; cyfra setek
		; wpisanie kodu koloru (intensywny bia�y) do pami�ci ekranu
		mov al, 00101111B
		mov es:[bx+1],al
		mov es:[bx+3],al
		mov es:[bx+5],al
		; odtworzenie rejestr�w
		pop dx
		pop cx
		pop ax
		ret ; wyj�cie z podprogramu
	wyswietl_AL ENDP
;============================================================
    klawiatura PROC
		push ax
		push bx
		push es

		; Odczyt kodu klawisza z portu 60h
		in al, 60h

		; Sprawdzenie, czy to make code (ignorujemy break code)
		test al, 80h
		jnz zakoncz_klawiatura

		; Adres pami�ci ekranu
		mov bx, 0B800h
		mov es, bx
		mov bx, cs:licznik
		
		in al, 60h

		; Wy�wietlenie kodu klawisza
		call wyswietl_AL

		; Przesuni�cie wska�nika na nast�pny znak
		add bx, 10
		cmp bx, 4000
		jb dalej
		mov bx, 0

		dalej:
		mov cs:licznik, bx

	zakoncz_klawiatura:
		; Przywr�cenie rejestr�w
		pop es
		pop bx
		pop ax

		; Wywo�anie starego obs�uguj�cego INT 9h
		jmp dword PTR cs:wektor9_klawiatura
		
		licznik dw 320 ; wy�wietlanie pocz�wszy od 2. wiersza
		wektor9_klawiatura dd ?
	klawiatura ENDP

;============================================================
; program g��wny - instalacja i deinstalacja procedury
; obs�ugi przerwa�
; ustalenie strony nr 0 dla trybu tekstowego
    zacznij:
        mov al, 0
        mov ah, 5
        int 10
        mov ax, 0
        mov ds, ax ; zerowanie rejestru DS

        ; Odczytanie oryginalnego wektora INT 9h
		mov eax, ds:[36] ; INT 9h wektor w pami�ci (36h = 9 * 4)
		mov cs:wektor9_klawiatura, eax

		; Zmiana wektora INT 9h na nasz� procedur� 'klawiatura'
		mov ax, SEG klawiatura
		mov bx, OFFSET klawiatura
		cli
		mov ds:[36], bx
		mov ds:[38], ax
		sti

        ; oczekiwanie na naci�ni�cie klawisza 'x'
    aktywne_oczekiwanie:
        mov ah, 1
        int 16H
        jz aktywne_oczekiwanie
        mov ah, 0
        int 16H
        cmp al, 'x'
        jne aktywne_oczekiwanie

        ; Przywr�cenie oryginalnego wektora INT 9h
		mov eax, cs:wektor9_klawiatura
		cli
		mov ds:[36], eax
		sti

        ; zako�czenie programu
        mov al, 0
        mov ah, 4CH
        int 21H

    rozkazy ENDS

    nasz_stos SEGMENT stack
        db 128 dup (?)
    nasz_stos ENDS

END zacznij

