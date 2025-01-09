.686
.model flat
public _avg_wd

.code
	_avg_wd PROC
		push ebp
		mov ebp, esp
		push ecx
		push ebx

		mov ecx, [ebp + 8] ; n
		mov eax, [ebp + 12] ; tablica liczb
		mov ebx, [ebp + 16] ; tablica wag
		dec ecx 

		finit

		fld dword ptr [eax + 4 * ecx] ; ST(0) = liczba z tablicy
		fld dword ptr [ebx + 4 * ecx] ; ST(0) = waga z tablicy, ST(1) = liczba z tablicy
		fmul ; ST(0) = liczba * waga
		dec ecx 

	petla:
		fld dword ptr [eax + 4 * ecx] ; ST(0) = liczba z tablicy, ST(1) = liczba * waga
		fld dword ptr [ebx + 4 * ecx] ; ST(0) = waga z tablicy, ST(1) = liczba z tablicy, ST(2) = liczba * waga
		fmul ; ST(0) = liczba * waga, ST(1) = liczba * waga
		fadd ; ST(0) = liczba * waga + liczba * waga
		dec ecx
		jns petla ; jns = jump not sign, czyli skok jesli nie ustawiony bit znaku (czyli jesli ecx >= 0)

		; ST(0) = suma wa¿ona

		mov ecx, [ebp + 8] ; n
		dec ecx
		fld dword ptr [ebx + 4 * ecx] ; ST(0) = waga z tablicy, ST(1) = suma wa¿ona
		dec ecx

	petla2:
		fld dword ptr [ebx + 4 * ecx] ; ST(0) = waga z tablicy, ST(1) = waga z tablicy, ST(2) = suma wa¿ona
		fadd ; ST(0) = suma wag, ST(1) = suma wa¿ona
		dec ecx
		jns petla2

		fdiv ; ST(0) = suma / n

		pop ebx
		pop ecx
		pop ebp
		ret
	_avg_wd ENDP
END