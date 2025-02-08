.686
.model flat

public _czy_pierwsza

.code
	_czy_pierwsza PROC
		push ebp
		mov ebp, esp
		push ecx

		xor ecx, ecx
		mov cx, [ebp + 8]
		sub cx, 1 ; a - 1 jest w ecx
		jz niepierwsza

	 petla:
		cmp cx, 1
		je pierwsza
		mov ax, [ebp + 8] ; m�odsza cz�� a jest w ax
		mov dx, [ebp + 10] ; starsza cz�� a jest w dx
		; liczba jest w dx:ax
		div cx ; dzielimy liczb� przez ni� - 1
		cmp dx, 0
		je niepierwsza
		dec cx
		jmp petla
		
	pierwsza:
		mov eax, '1'
		jmp koniec

	niepierwsza:
		mov eax, '0'

	koniec:
		pop ecx
		pop ebp
		ret
	_czy_pierwsza ENDP
END


