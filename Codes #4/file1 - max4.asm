.686
.model flat
public _szukaj4_max

.code
	_szukaj4_max PROC
		push ebp ; zapisanie zawartoœci EBP na stosie
		mov ebp, esp ; kopiowanie zawartoœci ESP do EBP

		mov eax, [ebp+8] ; liczba a [ebp + 8], b [ebp + 12], c [ebp + 16], d = [ebp + 20]
		cmp eax, [ebp+12] ; porównanie a z b
		jge a_wieksza_od_b
		
	b_wieksza_od_a:
		; a < b
		mov eax, [ebp + 12]
		cmp eax, [ebp + 16] 
		jge b_wieksza_od_a_c
		; b < c
		mov eax, [ebp + 16]
		cmp eax, [ebp + 20]
		jge c_max
		; c < d
		jmp d_max

	a_wieksza_od_b:
		mov eax, [ebp + 8]
		cmp eax, [ebp + 16]
		jge a_wieksza_od_b_c
		; a > c
		mov eax, [ebp + 16]
		cmp eax, [ebp + 20]
		jge a_max
		; c < d
		jmp d_max

	a_wieksza_od_b_c:
		cmp eax, [ebp + 20]
		jge a_max
		jmp d_max

	b_wieksza_od_a_c:
		cmp eax, [ebp + 20]
		jge b_max
		mov eax, [ebp + 20]
		jmp zakoncz

	a_max:
		mov eax, [ebp + 8]
		jmp zakoncz

	b_max:
		mov eax, [ebp + 12]
		jmp zakoncz

	c_max: 
		mov eax, [ebp + 16]
		jmp zakoncz

	d_max:
		mov eax, [ebp + 20]
		jmp zakoncz

	zakoncz:
		pop ebp
		ret
	_szukaj4_max ENDP
END