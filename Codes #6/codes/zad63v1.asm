.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy

;============================================================
; procedura obs³ugi przerwania zegarowego
    obsluga_zegara PROC
        ; przechowanie u¿ywanych rejestrów
        push ax
        push bx
        push es

        ; zwiêkszenie licznika przerwañ zegarowych
        inc cs:przerwania_licznik ; 

        ; sprawdzenie czy licznik osi¹gn¹³ wartoœæ 18
        cmp cs:przerwania_licznik, 18 ; 
        jne koniec_przerwania ;

        ; wyzerowanie licznika przerwañ
        mov cs:przerwania_licznik, 0 ;

        ; wpisanie adresu pamiêci ekranu do rejestru ES
        mov ax, 0B800h ;adres pamiêci ekranu
        mov es, ax

        ; zmienna 'licznik' zawiera adres bie¿¹cy w pamiêci ekranu
        mov bx, cs:licznik

        ; przes³anie do pamiêci ekranu kodu ASCII wyœwietlanego znaku
        ; i kodu koloru: bia³y na czarnym tle (do nastêpnego bajtu)
        mov byte PTR es:[bx], '*' ; kod ASCII
        mov byte PTR es:[bx+1], 00011110B ; ustawienie koloru

        ; przejœcie do nastêpnej linii
        add bx, 160 ; przejœcie o jedn¹ liniê w dó³ ; -----------------------------------------------------

        ; sprawdzenie czy adres bie¿¹cy osi¹gn¹³ koniec pamiêci ekranu
        cmp bx, 4000
        jb wysw_dalej ; skok gdy nie koniec ekranu

        ; ustawienie adresu pocz¹tku kolejnej kolumny
        mov bx, cs:kolumna ; -----------------------------------------------------
        add bx, 2          ; przesuniêcie do kolejnej kolumny -----------------------------------------------------
        cmp bx, 160        ; sprawdzenie, czy kolumna nie przekroczy³a szerokoœci ekranu -----------------------------------------------------
        jb reset_kolumny   ; jeœli nie, kontynuuj wyœwietlanie -----------------------------------------------------
        mov bx, 0          ; resetuj kolumnê, gdy osi¹gnie koniec ekranu -----------------------------------------------------

    reset_kolumny:
        mov cs:kolumna, bx ; zapisz now¹ kolumnê -----------------------------------------------------

    wysw_dalej:
        ; zapisanie adresu bie¿¹cego do zmiennej 'licznik'
        mov cs:licznik, bx

    koniec_przerwania:
        ; odtworzenie rejestrów
        pop es
        pop bx
        pop ax

        ; skok do oryginalnej procedury obs³ugi przerwania zegarowego
        jmp dword PTR cs:wektor8

        ; dane programu ze wzglêdu na specyfikê obs³ugi przerwañ
        ; umieszczone s¹ w segmencie kodu
        licznik dw 0      ; adres pocz¹tkowy w pamiêci ekranu
        kolumna dw 0      ; aktualna kolumna wyœwietlania -----------------------------------------------------
        wektor8 dd ?
        przerwania_licznik dw 0 ; licznik przerwañ zegarowych

    obsluga_zegara ENDP

;============================================================
; program g³ówny - instalacja i deinstalacja procedury
; obs³ugi przerwañ
; ustalenie strony nr 0 dla trybu tekstowego
    zacznij:
        mov al, 0
        mov ah, 5
        int 10
        mov ax, 0
        mov ds, ax ; zerowanie rejestru DS

        ; odczytanie zawartoœci wektora nr 8 i zapisanie go
        ; w zmiennej 'wektor8'
        mov eax, ds:[32] ; adres fizyczny 0*16 + 32 = 32
        mov cs:wektor8, eax

        ; wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
        mov ax, SEG obsluga_zegara ; czêœæ segmentowa adresu
        mov bx, OFFSET obsluga_zegara ; offset adresu
        cli ; zablokowanie przerwañ
        ; zapisanie adresu procedury do wektora nr 8
        mov ds:[32], bx ; OFFSET
        mov ds:[34], ax ; cz. segmentowa
        sti ;odblokowanie przerwañ

        ; oczekiwanie na naciœniêcie klawisza 'x'
    aktywne_oczekiwanie:
        mov ah, 1
        int 16H
        jz aktywne_oczekiwanie
        mov ah, 0
        int 16H
        cmp al, 'x'
        jne aktywne_oczekiwanie

        ; deinstalacja procedury obs³ugi przerwania zegarowego
        mov eax, cs:wektor8
        cli
        mov ds:[32], eax
        sti

        ; zakoñczenie programu
        mov al, 0
        mov ah, 4CH
        int 21H

    rozkazy ENDS

    nasz_stos SEGMENT stack
        db 128 dup (?)
    nasz_stos ENDS

END zacznij






COMMENT | 
				kolor - 0/1 mruganie, 3 bity koloru t³a, 4 bity koloru znaku 
				0000 - czarny
				0001 - niebieski
				0010 - zielony
				0011 - b³êkitny
				0100 - czerwony
				0101 - fioletowy
				0110 - br¹zowy
				0111 - jasnoszary
				1000 - ciemnoszary
				1001 - jasnoniebieski
				1010 - jasnozielony
				1011 - jasno b³êkitny
				1100 - jasnoczerwony
				1101 - jasnofioletowy
				1110 - ¿ó³ty
				1111 - bia³y 
		|