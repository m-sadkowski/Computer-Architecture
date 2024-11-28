.686
.model flat

public _odejmij_jeden

.code
	_odejmij_jeden PROC
		push ebp ; zapisanie zawartoœci EBP na stosie
		mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
		push ebx ; przechowanie zawartoœci rejestru EBX

		; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
		; w kodzie w jêzyku C
		mov ebx, [ebp+8] ; odczytanie adresu adresu zmiennej
		mov eax, [ebx] ; odczytanie wartoœci adresu zmiennej
		mov ebx, [eax] ; odczytanie wartoœci zmiennej
		dec ebx

		mov [eax], ebx ; zapisanie zmiennej do pamiêci, [] - oznacza, ¿e zmienna jest pod adresem w rejestrze eax

		pop ebx
		pop ebp
		ret
	_odejmij_jeden ENDP
END
