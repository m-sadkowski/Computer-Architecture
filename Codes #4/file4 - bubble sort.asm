.686
.model flat

public _sort

.code
    _sort PROC
        push ebp                ; zapisanie zawarto�ci EBP na stosie
        mov ebp, esp            ; kopiowanie zawarto�ci ESP do EBP
        push ebx                ; przechowanie rejestru EBX
        push esi                ; przechowanie rejestru ESI
        push edi                ; przechowanie rejestru EDI
    
        mov edi, [ebp+8]        ; adres tablicy tabl -> edi
        mov esi, [ebp+12]       ; liczba element�w tablicy n -> esi

        dec esi                 ; zmniejszenie liczby element�w o 1 (ostatni indeks)
    
    outer_loop:
        mov ecx, esi            ; ustaw licznik p�tli wewn�trznej

        mov ebx, edi            ; ustaw wska�nik pocz�tku tablicy

    inner_loop:
        mov eax, [ebx]          ; wczytaj bie��cy element tablicy
        cmp eax, [ebx+4]        ; por�wnaj z nast�pnym elementem
        jle no_swap             ; je�li bie��cy <= nast�pny, pomi� zamian�

        ; zamie� s�siednie elementy
        mov edx, [ebx+4]        ; wczytaj nast�pny element
        mov [ebx], edx          ; przepisz nast�pny do bie��cego
        mov [ebx+4], eax        ; przepisz bie��cy do nast�pnego

    no_swap:
        add ebx, 4              ; przejd� do nast�pnej pary element�w
        loop inner_loop         ; zmniejsz ECX i powt�rz p�tl�, je�li ECX > 0

        dec esi                 ; zmniejsz d�ugo�� n na potrzeby nast�pnej iteracji
        jg outer_loop           ; je�li n > 0, kontynuuj p�tl� zewn�trzn�

        pop edi                 ; odtw�rz rejestr EDI
        pop esi                 ; odtw�rz rejestr ESI
        pop ebx                 ; odtw�rz rejestr EBX
        pop ebp                 ; odtw�rz rejestr EBP
        ret                     ; powr�t do programu g��wnego
    _sort ENDP
END
