.686
.model flat
public _pole_kola

.code
	_pole_kola PROC
		push ebp
		mov ebp, esp

		mov eax, [ebp + 8] ; adres pod którym jest promieñ
		finit ; inicjalizacja koprocesora arytmetycznego
		fld dword ptr [eax] ; za³adowanie promienia na stos ST(0) = r)
		fld dword ptr [eax] ; za³adowanie promienia na stos ST(0) = r, ST(1) = r
		fmulp ; ST(0) = r^2
		fldpi ; za³adowanie liczby pi na stos ST(0) = pi, ST(1) = r^2
		fmulp ; ST(0) = pi*r^2
		fstp dword ptr [eax] ; zapisanie wyniku (ST(0)) pod adres promienia

		pop ebp
		ret
	_pole_kola ENDP
END