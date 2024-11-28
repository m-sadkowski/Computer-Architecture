.686
.model flat

public _sort

.code
    _sort PROC
        push ebp                ; zapisanie zawartoœci EBP na stosie
        mov ebp, esp            ; kopiowanie zawartoœci ESP do EBP
        push ebx                ; przechowanie rejestru EBX
        push esi                ; przechowanie rejestru ESI
        push edi                ; przechowanie rejestru EDI
    
        mov edi, [ebp+8]        ; adres tablicy tabl -> edi
        mov esi, [ebp+12]       ; liczba elementów tablicy n -> esi

        dec esi                 ; zmniejszenie liczby elementów o 1 (ostatni indeks)
    
    outer_loop:
        mov ecx, esi            ; ustaw licznik pêtli wewnêtrznej

        mov ebx, edi            ; ustaw wskaŸnik pocz¹tku tablicy

    inner_loop:
        mov eax, [ebx]          ; wczytaj bie¿¹cy element tablicy
        cmp eax, [ebx+4]        ; porównaj z nastêpnym elementem
        jle no_swap             ; jeœli bie¿¹cy <= nastêpny, pomiñ zamianê

        ; zamieñ s¹siednie elementy
        mov edx, [ebx+4]        ; wczytaj nastêpny element
        mov [ebx], edx          ; przepisz nastêpny do bie¿¹cego
        mov [ebx+4], eax        ; przepisz bie¿¹cy do nastêpnego

    no_swap:
        add ebx, 4              ; przejdŸ do nastêpnej pary elementów
        loop inner_loop         ; zmniejsz ECX i powtórz pêtlê, jeœli ECX > 0

        dec esi                 ; zmniejsz d³ugoœæ n na potrzeby nastêpnej iteracji
        jg outer_loop           ; jeœli n > 0, kontynuuj pêtlê zewnêtrzn¹

        pop edi                 ; odtwórz rejestr EDI
        pop esi                 ; odtwórz rejestr ESI
        pop ebx                 ; odtwórz rejestr EBX
        pop ebp                 ; odtwórz rejestr EBP
        ret                     ; powrót do programu g³ównego
    _sort ENDP
END
