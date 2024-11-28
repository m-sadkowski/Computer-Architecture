.686
.model flat

public _liczba_przeciwna

.code
	_liczba_przeciwna PROC
		push ebp ; zapisanie zawartoœci EBP na stosie
		mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
		push ebx ; przechowanie zawartoœci rejestru EBX

		; wpisanie do rejestru EBX adresu zmiennej zdefiniowanej
		; w kodzie w jêzyku C
		mov ebx, [ebp+8]
		mov eax, [ebx] ; odczytanie wartoœci zmiennej

		bt eax, 31 ; sprawdzenie najstarszego bitu
		jc liczba_ujemna
		not eax
		add eax, 1
		jmp koniec

	liczba_ujemna:
		sub eax, 1
		not eax

	koniec:
		mov [ebx], eax ; odes³anie wyniku do zmiennej
		; uwaga: trzy powy¿sze rozkazy mo¿na zast¹piæ jednym rozkazem
		; w postaci: inc dword PTR [ebx]

		pop ebx
		pop ebp
		ret
	_liczba_przeciwna ENDP
END
