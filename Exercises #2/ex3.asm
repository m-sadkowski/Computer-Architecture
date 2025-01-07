.686
.model flat
extern _malloc : PROC
public _komunikat

.code
	_komunikat PROC
		push ebp
		mov ebp, esp

		push esi
		push edi
		push ebx

		mov esi, [ebp+8] ; w ESI adres oryginalnego napisu
		mov ebx, 0 ; iterator
		mov ecx, 0 ; ile znakow ma oryginalny napis

	ileZnakow:
		mov dl, [esi][ecx]
		cmp dl, 0
		je dalej
		inc ecx
		jmp ileZnakow

	dalej:
		cmp ecx, 0 ; jezeli napis jest pusty
		je koniec

		; Rezerwacja pamiêci przez _malloc
		add ecx, 5
		push ecx
		call _malloc
		pop ecx
		sub ecx, 5

	petla:
		mov dl, [esi][ebx]
		mov [eax][ebx], dl
		inc ebx
		loop petla

		mov [eax][ebx], byte ptr 'B'
		inc ebx
		mov [eax][ebx], byte ptr 'l'
		inc ebx
		mov [eax][ebx], byte ptr 'a'
		inc ebx
		mov [eax][ebx], byte ptr 'd'
		inc ebx
		mov [eax][ebx], byte ptr '.'
		inc ebx

	koniec:
		pop ebx
		pop edi
		pop esi
		pop ebp
		ret
	_komunikat ENDP
END