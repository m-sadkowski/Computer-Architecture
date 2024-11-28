.686
.model flat

public _sort

.code
	_sort PROC
		push ebp ; zapisanie zawartoœci EBP na stosie
		mov ebp,esp ; kopiowanie zawartoœci ESP do EBP
		push ebx ; przechowanie zawartoœci rejestru EBX
		push esi ; przechowanie zawartoœci rejestru ESI

		mov ebx, [ebp+8] ; adres tablicy 
		mov ecx, [ebp+12] ; liczba elementów tablicy
		mov esi, ecx ; liczba obiegów pêtli
		dec ecx ; zamiana liczby elementów na index ostatniej liczby

	sortowanie:
		; wpisanie kolejnego elementu tablicy do rejestru EAX
		ptl: mov eax, [ebx]

		; porównanie elementu tablicy wpisanego do EAX z nastêpnym
		cmp eax, [ebx+4]
		jle gotowe ; skok, gdy nie ma przestawiania

		; zamiana s¹siednich elementów tablicy
		mov edx, [ebx+4]
		mov [ebx], edx
		mov [ebx+4], eax

	gotowe:
		add ebx, 4 ; wyznaczenie adresu kolejnego elementu
		loop ptl ; organizacja pêtli

		dec esi ; zmniejszenie liczby obiegów pêtli
		mov ecx, esi ; przypisanie liczby obiegów pêtli do rejestru ECX
		mov ebx, [ebp+8] ; przypisanie adresu tablicy do rejestru EBX
		cmp esi, 0 ; porównanie liczby obiegów pêtli z zerem
		jne sortowanie ; skok, gdy liczba obiegów pêtli jest ró¿na od zera

		pop esi ; odtworzenie zawartoœci rejestru ESI
		pop ebx ; odtworzenie zawartoœci rejestrów
		pop ebp
		ret ; powrót do programu g³ównego
	_sort ENDP
END