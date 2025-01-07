.686
.model flat
public _szukaj_elem_min

.code
	_szukaj_elem_min PROC
		push ebp
		mov ebp, esp

		push esi
		push ecx
		push ebx

		mov esi, [ebp + 8] ; tablica oryginalna
		mov eax, esi ; wskaznik na element bedacy wynikiem, pierwotnie pierwszy element tablicy
		mov ecx, 0 ; iterator w petli

	petla:
		; obs³uga pêtli (od 0 do n)
		inc ecx
		cmp ecx, [ebp + 12] ; porownanie obecnego iteratora z liczba elementow tablicy
		je koniec
		; porownywanie kolejnych liczb
		mov ebx, [eax] ; w ebx wartosc obecnego najwiekszego elementu
		cmp ebx, [esi + 4 * ecx] ; porownanie obecnego najwiekszego elementu z kolejnym elementem tablicy
		jng petla ; jesli obecny jest wiekszy to przejdz do kolejnej iteracji
		lea eax, [esi + 4 * ecx] ; zapisz w eax adres nowego najwiekszego elementu
		jmp petla

	koniec:
		pop ebx
		pop ecx
		pop esi
		pop ebp

		ret
	_szukaj_elem_min ENDP
END