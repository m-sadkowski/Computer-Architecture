.686
.model flat
public _nowy_exp

.data
mnoznik dd 1

.code
	_nowy_exp PROC
		push ebp ; zapisanie zawartoœci EBP na stosie
		mov ebp, esp ; kopiowanie zawartoœci ESP do EBP

		finit ; inicjalizacja koprocesora

		fld dword ptr [ebp + 8] ; za³adowanie x na stos koprocesora
		fld1 ; za³adowanie 1 na stos koprocesora
		fld1 ; za³adowanie 1 na stos koprocesora
		fld1 ; za³adowanie 1 na stos koprocesora
		; ST(0) = 1, ST(1) = 1, ST(2) = 1, ST(3) = x
		; suma, mianownik, licznik, x

		mov ecx, 19

	ptl:
		; ST(0) = suma, ST(1) = mianownik, ST(2) = licznik, ST(3) = x

		fld st(2) ; na wierzcho³ek przesy³amy licznik
		; ST(0) = licznik, ST(1) = suma, ST(2) = mianownik, ST(3) = licznik, ST(4) = x

		fmul st(0), st(4)
		; ST(0) = licznik * x, ST(1) = suma, ST(2) = mianownik, ST(3) = licznik, ST(4) = x

		fst st(3)
		; ST(0) = licznik * x, ST(1) = suma, ST(2) = mianownik, ST(3) = licznik * x, ST(4) = x

		fild dword ptr mnoznik
		; ST(0) = mnoznik, ST(1) = licznik * x, ST(2) = suma, ST(3) = mianownik, ST(4) = licznik * x, ST(5) = x

		fmul st(0), st(3)
		; ST(0) = mnoznik * mianownik, ST(1) = licznik * x, ST(2) = suma, ST(3) = mianownik, ST(4) = licznik * x, ST(5) = x

		fst st(3)
		; ST(0) = mnoznik * mianownik, ST(1) = licznik * x, ST(2) = suma, ST(3) = mnoznik * mianownik, ST(4) = licznik * x, ST(5) = x

		fdivp
		; ST(0) = (licznik * x) / (mnoznik * mianownik), ST(1) = licznik * x, ST(2) = suma, ST(3) = mnoznik * mianownik, ST(4) = licznik * x, ST(5) = x
		; ST(0) = (licznik * x) / (mnoznik * mianownik), ST(1) = suma, ST(2) = mnoznik * mianownik, ST(3) = licznik * x, ST(4) = x

		faddp
		; ST(0) = ((licznik * x) / (mnoznik * mianownik)) + suma, ST(1) = suma, ST(2) = mnoznik * mianownik, ST(3) = licznik * x, ST(4) = x
		; ST(0) = ((licznik * x) / (mnoznik * mianownik)) + suma, ST(1) = mnoznik * mianownik, ST(2) = licznik * x, ST(3) = x

		add dword ptr mnoznik, 1 ; mnoznik++

		dec ecx ; zmniejszenie licznika pêtli
		jnz ptl

		pop ebp
		ret
	_nowy_exp ENDP
END