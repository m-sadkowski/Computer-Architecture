.686
.model flat
public _roznica

.code
	_roznica PROC
		push ebp 
		mov ebp, esp 

		push ebx

		mov eax, [ebp+8] ; pobranie adresu pierwszego argumentu
		mov eax, [eax] ; pobranie wartosci pierwszego argumentu (a)
		mov ebx, [ebp+12] ; pobranie adresu adresu drugiego argumentu (b)
		mov ebx, [ebx]
		mov ebx, [ebx] ; pobranie wartosci drugiego argumentu (b)
		sub eax, ebx ; odejmowanie b od a

		pop ebx
		pop ebp
		ret
	_roznica ENDP
END