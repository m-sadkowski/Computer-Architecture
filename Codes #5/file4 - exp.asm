.686
.model flat
public _nowy_exp

.data

.code
	_nowy_exp PROC
		push ebp ; zapisanie zawartoœci EBP na stosie
		mov ebp, esp ; kopiowanie zawartoœci ESP do EBP

		finit ; inicjalizacja koprocesora

		mov ecx, 1 ; i = 1

		fld1 ; ST(0) = 1 ; suma
		fld1 ; ST(1) = 1 ; pierwotne i

	petla: 
		push ecx
		fild dword PTR [esp]
		pop ecx
		; ST(0) = i, ST(1) = suma, ST(2) = poprzednie i

		fmul ST(0), ST(2) 
		fstp ST(2)
		; ST(0) = i * poprzednie i, ST(1) = suma

		fld dword PTR [ebp + 8] 
		; ST(0) = x, ST(1) = i * poprzednie i, ST(2) = suma

		mov edx, ecx
	potega:
		fld dword ptr [ebp + 8] 
        fmulp st(1), st(0)
		dec edx
		jnz potega
		; ST(0) = x^i, ST(1) = i * poprzednie i, ST(2) = suma

		fdivr ST(0), ST(2)
		; ST(0) = x^i / (i * poprzednie i), ST(1) = i * poprzednie i, ST(2) = suma

		fadd ST(0), ST(2) 
		; ST(0) = suma + x^i / (i * poprzednie i), ST(1) = i * poprzednie i, ST(2) = suma


		inc ecx
		cmp ecx, 19
		jne petla

		pop ebp
		ret
	_nowy_exp ENDP
END