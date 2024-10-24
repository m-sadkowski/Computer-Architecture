.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
extern __write : PROC
extern __read : PROC
public _main

.data
    tekst_pocz db 10, 'Prosze wpisac tekst:', 10 ; tekst pocz�tkowy
    koniec_t db ?  ; koniec tekstu pocz�tkowego
    magazyn db 80 dup (?) ; bufor na tekst wprowadzony przez u�ytkownika
    bufor_utf16 db 160 dup (?) ; bufor na tekst przekonwertowany do UTF-16
    wynik db 80 dup (?) ; bufor na wynikowy tekst po zamianach
    nowa_linia db 10  ; znak nowej linii
    liczba_znakow dd ?  ; liczba wprowadzonych znak�w
    tytul dw 10, 'S', 'k', 'o', 'n', 'w', 'e', 'r', 't', 'o', 'w', 'a', 'n', 'y', 0 ; tytu� okna MessageBoxa

.code
    _main PROC
        ; Wy�wietlenie tekstu informacyjnego "Prosze wpisac tekst:"
        mov ecx, (OFFSET koniec_t) - (OFFSET tekst_pocz) ; obliczenie d�ugo�ci tekstu
        push ecx
        push OFFSET tekst_pocz ; przekazanie adresu tekstu do wy�wietlenia
        push 1 ; urz�dzenie 1 = ekran
        call __write ; wy�wietlenie tekstu na ekranie
        add esp, 12 ; czyszczenie stosu po wywo�aniu

        ; Odczytanie tekstu wprowadzonego przez u�ytkownika
        push 80 ; maksymalna liczba znak�w
        push OFFSET magazyn ; adres bufora, w kt�rym zostanie zapisany tekst
        push 0 ; urz�dzenie 0 = klawiatura
        call __read ; odczytanie danych z klawiatury
        add esp, 12 ; czyszczenie stosu po wywo�aniu

        ; Zapisanie liczby wprowadzonych znak�w do zmiennej liczba_znakow
        mov liczba_znakow, eax ; eax zawiera liczb� przeczytanych znak�w

        ; Inicjalizacja rejestr�w
        mov ecx, eax ; liczba wprowadzonych znak�w
        mov ebx, 0 ; indeks do bufora "magazyn"
        mov edx, 0 ; indeks do bufora wynikowego "wynik"

    ptl:
        ; P�tla przetwarzaj�ca ka�dy znak wprowadzony przez u�ytkownika
        mov al, magazyn[ebx] ; pobranie znaku z bufora "magazyn"

        ; Sprawdzenie, czy znak to 'm', aby znale�� odpowiedni� sekwencj�
        cmp al, 'm' ; czy to 'm'?
        je sprawdz_maj ; je�li tak, sprawd�, czy to "maj"
        jmp dalej ; je�li �adne, id� dalej

    sprawdz_maj:
        ; Sprawdzanie, czy kolejne znaki tworz� sekwencj� "maj"
        cmp byte ptr [magazyn+ebx+1], 'a' ; czy po 'm' jest 'a'?
        jne dalej ; je�li nie, id� dalej
        cmp byte ptr [magazyn+ebx+2], 'j' ; czy po 'ma' jest 'j'?
        jne dalej

        ; Je�li znaleziono "maj", zamie� na '5'
        mov byte ptr [wynik+edx], '5' ; zapisz '5' w buforze wynikowym
        inc edx ; zwi�ksz indeks wyniku

        ; Pomijamy trzy znaki ("maj") w buforze "magazyn"
        add ebx, 3
        sub ecx, 3 ; dostosowanie liczby znak�w do przetworzenia
        jmp dalej ; przej�cie do dalszego przetwarzania

    dalej:
        ; Kopiowanie bie��cego znaku do bufora wynikowego, je�li nie by�o zamiany
        mov al, magazyn[ebx] ; pobranie bie��cego znaku z "magazyn"
        mov byte ptr [wynik+edx], al ; zapisanie go do "wynik"
        inc edx ; zwi�kszenie indeksu w buforze wynikowym
        inc ebx ; przej�cie do kolejnego znaku w "magazyn"
        dec ecx ; zmniejszenie liczby pozosta�ych znak�w do przetworzenia
        jnz ptl ; je�li s� jeszcze znaki, powt�rz p�tl�

        ; Zako�czenie bufora wynikowego znakiem 0 (null terminator)
        mov byte ptr [wynik+edx], 0

        ; Przekszta�cenie tekstu z bufora wynikowego na UTF-16
        mov esi, OFFSET wynik ; adres �r�d�owego tekstu (wynik)
        mov edi, OFFSET bufor_utf16 ; adres bufora na tekst w UTF-16
        mov ecx, edx ; liczba znak�w do przekszta�cenia

    konwersja_znakow:
        ; P�tla przekszta�caj�ca ka�dy znak na UTF-16
        mov al, [esi] ; pobranie znaku z bufora wynikowego
        mov ah, 0 ; ustawienie starszego bajtu na 0 (UTF-16)
        mov [edi], ax ; zapisanie znaku w UTF-16 do bufora
        add esi, 1 ; przej�cie do kolejnego znaku
        add edi, 2 ; przesuni�cie wska�nika w buforze UTF-16
        loop konwersja_znakow ; powtarzanie dla kolejnych znak�w

        ; Zako�czenie bufora UTF-16 znakiem 0
        mov word ptr [edi], 000H

        ; Wy�wietlenie przekszta�conego tekstu za pomoc� MessageBoxW
        push 0 ; uchwyt okna nadrz�dnego
        push OFFSET tytul ; tytu� okna
        push OFFSET bufor_utf16 ; przekszta�cony tekst w UTF-16
        push 0 ; rodzaj okna (bez ikon)
        call _MessageBoxW@16 ; wy�wietlenie okna
        add esp, 16 ; czyszczenie stosu po wywo�aniu

        ; Zako�czenie programu
        call _ExitProcess@4
    _main ENDP
END
