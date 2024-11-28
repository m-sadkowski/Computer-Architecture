.686
.model flat

public _sort

.code
	_sort PROC
		push ebp ; zapisanie zawarto�ci EBP na stosie
		mov ebp,esp ; kopiowanie zawarto�ci ESP do EBP
		push ebx ; przechowanie zawarto�ci rejestru EBX
		push esi ; przechowanie zawarto�ci rejestru ESI

		mov ebx, [ebp+8] ; adres tablicy 
		mov ecx, [ebp+12] ; liczba element�w tablicy
		mov esi, ecx ; liczba obieg�w p�tli
		dec ecx ; zamiana liczby element�w na index ostatniej liczby

	sortowanie:
		; wpisanie kolejnego elementu tablicy do rejestru EAX
		ptl: mov eax, [ebx]

		; por�wnanie elementu tablicy wpisanego do EAX z nast�pnym
		cmp eax, [ebx+4]
		jle gotowe ; skok, gdy nie ma przestawiania

		; zamiana s�siednich element�w tablicy
		mov edx, [ebx+4]
		mov [ebx], edx
		mov [ebx+4], eax

	gotowe:
		add ebx, 4 ; wyznaczenie adresu kolejnego elementu
		loop ptl ; organizacja p�tli

		dec esi ; zmniejszenie liczby obieg�w p�tli
		mov ecx, esi ; przypisanie liczby obieg�w p�tli do rejestru ECX
		mov ebx, [ebp+8] ; przypisanie adresu tablicy do rejestru EBX
		cmp esi, 0 ; por�wnanie liczby obieg�w p�tli z zerem
		jne sortowanie ; skok, gdy liczba obieg�w p�tli jest r�na od zera

		pop esi ; odtworzenie zawarto�ci rejestru ESI
		pop ebx ; odtworzenie zawarto�ci rejestr�w
		pop ebp
		ret ; powr�t do programu g��wnego
	_sort ENDP
END