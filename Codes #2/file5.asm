.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
    tekst_pocz db 10, 'Prosze wpisac tekst:', 10 ; tekst pocz¹tkowy
    koniec_t db ?  ; koniec tekstu pocz¹tkowego
    magazyn db 80 dup (?) ; bufor na tekst wprowadzony przez u¿ytkownika
    bufor_utf16 db 160 dup (?) ; bufor na tekst przekonwertowany do UTF-16
    wynik db 80 dup (?) ; bufor na wynikowy tekst po zamianach
    nowa_linia db 10  ; znak nowej linii
    liczba_znakow dd ?  ; liczba wprowadzonych znaków
    tytul dw 10, 'S', 'k', 'o', 'n', 'w', 'e', 'r', 't', 'o', 'w', 'a', 'n', 'y', 0 ; tytu³ okna MessageBoxa

.code
    _main PROC
        ; Wyœwietlenie tekstu informacyjnego "Prosze wpisac tekst:"
        mov ecx, (OFFSET koniec_t) - (OFFSET tekst_pocz) ; obliczenie d³ugoœci tekstu
        push ecx
        push OFFSET tekst_pocz ; przekazanie adresu tekstu do wyœwietlenia
        push 1 ; urz¹dzenie 1 = ekran
        call __write ; wyœwietlenie tekstu na ekranie
        add esp, 12 ; czyszczenie stosu po wywo³aniu

        ; Odczytanie tekstu wprowadzonego przez u¿ytkownika
        push 80 ; maksymalna liczba znaków
        push OFFSET magazyn ; adres bufora, w którym zostanie zapisany tekst
        push 0 ; urz¹dzenie 0 = klawiatura
        call __read ; odczytanie danych z klawiatury
        add esp, 12 ; czyszczenie stosu po wywo³aniu

        ; Zapisanie liczby wprowadzonych znaków do zmiennej liczba_znakow
        mov liczba_znakow, eax ; eax zawiera liczbê przeczytanych znaków

        ; Inicjalizacja rejestrów
        mov ecx, eax ; liczba wprowadzonych znaków
        mov ebx, 0 ; indeks do bufora "magazyn"
        mov edx, 0 ; indeks do bufora wynikowego "wynik"

    ptl:
        ; Pêtla przetwarzaj¹ca ka¿dy znak wprowadzony przez u¿ytkownika
        mov al, magazyn[ebx] ; pobranie znaku z bufora "magazyn"

        ; Sprawdzenie, czy znak to 'm', aby znaleŸæ odpowiedni¹ sekwencjê
        cmp al, 'm' ; czy to 'm'?
        je sprawdz_maj ; jeœli tak, sprawdŸ, czy to "maj"
        jmp dalej ; jeœli ¿adne, idŸ dalej

    sprawdz_maj:
        ; Sprawdzanie, czy kolejne znaki tworz¹ sekwencjê "maj"
        cmp byte ptr [magazyn+ebx+1], 'a' ; czy po 'm' jest 'a'?
        jne dalej ; jeœli nie, idŸ dalej
        cmp byte ptr [magazyn+ebx+2], 'j' ; czy po 'ma' jest 'j'?
        jne dalej

        ; Jeœli znaleziono "maj", zamieñ na '5'
        mov byte ptr [wynik+edx], '5' ; zapisz '5' w buforze wynikowym
        inc edx ; zwiêksz indeks wyniku

        ; Pomijamy trzy znaki ("maj") w buforze "magazyn"
        add ebx, 3
        sub ecx, 3 ; dostosowanie liczby znaków do przetworzenia
        jmp dalej ; przejœcie do dalszego przetwarzania

    dalej:
        ; Kopiowanie bie¿¹cego znaku do bufora wynikowego, jeœli nie by³o zamiany
        mov al, magazyn[ebx] ; pobranie bie¿¹cego znaku z "magazyn"
        mov byte ptr [wynik+edx], al ; zapisanie go do "wynik"
        inc edx ; zwiêkszenie indeksu w buforze wynikowym
        inc ebx ; przejœcie do kolejnego znaku w "magazyn"
        dec ecx ; zmniejszenie liczby pozosta³ych znaków do przetworzenia
        jnz ptl ; jeœli s¹ jeszcze znaki, powtórz pêtlê

        ; Zakoñczenie bufora wynikowego znakiem 0 (null terminator)
        mov byte ptr [wynik+edx], 0

        ; Przekszta³cenie tekstu z bufora wynikowego na UTF-16
        mov esi, OFFSET wynik ; adres Ÿród³owego tekstu (wynik)
        mov edi, OFFSET bufor_utf16 ; adres bufora na tekst w UTF-16
        mov ecx, edx ; liczba znaków do przekszta³cenia

    konwersja_znakow:
        ; Pêtla przekszta³caj¹ca ka¿dy znak na UTF-16
        mov al, [esi] ; pobranie znaku z bufora wynikowego
        mov ah, 0 ; ustawienie starszego bajtu na 0 (UTF-16)
        mov [edi], ax ; zapisanie znaku w UTF-16 do bufora
        add esi, 1 ; przejœcie do kolejnego znaku
        add edi, 2 ; przesuniêcie wskaŸnika w buforze UTF-16
        loop konwersja_znakow ; powtarzanie dla kolejnych znaków

        ; Zakoñczenie bufora UTF-16 znakiem 0
        mov word ptr [edi], 000H

        ; Wyœwietlenie przekszta³conego tekstu za pomoc¹ MessageBoxW
        push 0 ; uchwyt okna nadrzêdnego
        push OFFSET tytul ; tytu³ okna
        push OFFSET bufor_utf16 ; przekszta³cony tekst w UTF-16
        push 0 ; rodzaj okna (bez ikon)
        call _MessageBoxW@16 ; wyœwietlenie okna
        add esp, 16 ; czyszczenie stosu po wywo³aniu

        ; Zakoñczenie programu
        call _ExitProcess@4
    _main ENDP
END
