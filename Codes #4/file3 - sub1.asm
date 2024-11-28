.686
.model flat

public _odejmij_jeden

.code
	_odejmij_jeden PROC
		push ebp ; zapisanie zawarto�ci EBP na stosie
		mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
		push ebx ; przechowanie zawarto�ci rejestru EBX

		; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
		; w kodzie w j�zyku C
		mov ebx, [ebp+8] ; odczytanie adresu adresu zmiennej
		mov eax, [ebx] ; odczytanie warto�ci adresu zmiennej
		mov ebx, [eax] ; odczytanie warto�ci zmiennej
		dec ebx

		mov [eax], ebx ; zapisanie zmiennej do pami�ci, [] - oznacza, �e zmienna jest pod adresem w rejestrze eax

		pop ebx
		pop ebp
		ret
	_odejmij_jeden ENDP
END
