.686
.model flat
public _srednia_harm

.data

jeden dd 1.0
bufor dd ?

.code
	_srednia_harm PROC
		push ebp ; zapisanie zawarto�ci EBP na stosie
		mov ebp, esp ; kopiowanie zawarto�ci ESP do EBP

		finit ; inicjalizacja koprocesora

		mov ebx, [ebp + 12] ; n jest w ebx
		mov esi, [ebp + 8] ; adres tablicy jest w esi

		mov ecx, ebx
		dec ecx

		fld dword ptr [esi + 4 * ecx] ; za�adowanie ostatniego elementu tablicy na stos
		fld jeden ; ST(0) = 1, ST(1) = tab[0]
		fdiv ST(0), ST(1) ; 1 / tab[0]

	petla:
		dec ecx
		fld dword ptr [esi + 4 * ecx] ; za�adowanie kolejnego (od ko�ca) elementu tablicy na stos
		fld jeden ; ST(0) = 1, ST(1) = tab[0], ST(2) = poprzedni element
		fdiv ST(0), ST(1) ; 1 / tab[0]
		fadd ST(0), ST(2) ; ST(0) = biezacy + poprzedni
		fstp ST(2) ; usu� poprzedni� sum�
		jnz petla

		fild dword ptr [ebp+12]
		fdiv ST(0), ST(1) ; ST(0) = suma / n

		pop ebp
		ret
	_srednia_harm ENDP
END