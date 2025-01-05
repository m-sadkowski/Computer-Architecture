.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy

;============================================================
; procedura obs�ugi przerwania zegarowego
    obsluga_zegara PROC
        ; przechowanie u�ywanych rejestr�w
        push ax
        push bx
        push es

        ; zwi�kszenie licznika przerwa� zegarowych
        inc cs:przerwania_licznik ; 

        ; sprawdzenie czy licznik osi�gn�� warto�� 18
        cmp cs:przerwania_licznik, 18 ; 
        jne koniec_przerwania ;

        ; wyzerowanie licznika przerwa�
        mov cs:przerwania_licznik, 0 ;

        ; wpisanie adresu pami�ci ekranu do rejestru ES
        mov ax, 0B800h ;adres pami�ci ekranu
        mov es, ax

        ; zmienna 'licznik' zawiera adres bie��cy w pami�ci ekranu
        mov bx, cs:licznik

        ; przes�anie do pami�ci ekranu kodu ASCII wy�wietlanego znaku
        ; i kodu koloru: bia�y na czarnym tle (do nast�pnego bajtu)
        mov byte PTR es:[bx], '*' ; kod ASCII
        mov byte PTR es:[bx+1], 00011110B ; ustawienie koloru

        ; przej�cie do nast�pnej linii
        add bx, 160 ; przej�cie o jedn� lini� w d� ; -----------------------------------------------------

        ; sprawdzenie czy adres bie��cy osi�gn�� koniec pami�ci ekranu
        cmp bx, 4000
        jb wysw_dalej ; skok gdy nie koniec ekranu

        ; ustawienie adresu pocz�tku kolejnej kolumny
        mov bx, cs:kolumna ; -----------------------------------------------------
        add bx, 2          ; przesuni�cie do kolejnej kolumny -----------------------------------------------------
        cmp bx, 160        ; sprawdzenie, czy kolumna nie przekroczy�a szeroko�ci ekranu -----------------------------------------------------
        jb reset_kolumny   ; je�li nie, kontynuuj wy�wietlanie -----------------------------------------------------
        mov bx, 0          ; resetuj kolumn�, gdy osi�gnie koniec ekranu -----------------------------------------------------

    reset_kolumny:
        mov cs:kolumna, bx ; zapisz now� kolumn� -----------------------------------------------------

    wysw_dalej:
        ; zapisanie adresu bie��cego do zmiennej 'licznik'
        mov cs:licznik, bx

    koniec_przerwania:
        ; odtworzenie rejestr�w
        pop es
        pop bx
        pop ax

        ; skok do oryginalnej procedury obs�ugi przerwania zegarowego
        jmp dword PTR cs:wektor8

        ; dane programu ze wzgl�du na specyfik� obs�ugi przerwa�
        ; umieszczone s� w segmencie kodu
        licznik dw 0      ; adres pocz�tkowy w pami�ci ekranu
        kolumna dw 0      ; aktualna kolumna wy�wietlania -----------------------------------------------------
        wektor8 dd ?
        przerwania_licznik dw 0 ; licznik przerwa� zegarowych

    obsluga_zegara ENDP

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

        ; odczytanie zawarto�ci wektora nr 8 i zapisanie go
        ; w zmiennej 'wektor8'
        mov eax, ds:[32] ; adres fizyczny 0*16 + 32 = 32
        mov cs:wektor8, eax

        ; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
        mov ax, SEG obsluga_zegara ; cz�� segmentowa adresu
        mov bx, OFFSET obsluga_zegara ; offset adresu
        cli ; zablokowanie przerwa�
        ; zapisanie adresu procedury do wektora nr 8
        mov ds:[32], bx ; OFFSET
        mov ds:[34], ax ; cz. segmentowa
        sti ;odblokowanie przerwa�

        ; oczekiwanie na naci�ni�cie klawisza 'x'
    aktywne_oczekiwanie:
        mov ah, 1
        int 16H
        jz aktywne_oczekiwanie
        mov ah, 0
        int 16H
        cmp al, 'x'
        jne aktywne_oczekiwanie

        ; deinstalacja procedury obs�ugi przerwania zegarowego
        mov eax, cs:wektor8
        cli
        mov ds:[32], eax
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






COMMENT | 
				kolor - 0/1 mruganie, 3 bity koloru t�a, 4 bity koloru znaku 
				0000 - czarny
				0001 - niebieski
				0010 - zielony
				0011 - b��kitny
				0100 - czerwony
				0101 - fioletowy
				0110 - br�zowy
				0111 - jasnoszary
				1000 - ciemnoszary
				1001 - jasnoniebieski
				1010 - jasnozielony
				1011 - jasno b��kitny
				1100 - jasnoczerwony
				1101 - jasnofioletowy
				1110 - ��ty
				1111 - bia�y 
		|