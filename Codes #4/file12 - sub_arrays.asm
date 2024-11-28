.686
.model flat
public _roznica
extern _malloc : PROC

.code
	_roznica PROC
		push ebp
		mov ebp, esp

		push edx
		push esi
		push edi

		mov edx, [ebp + 8] ; adres a w edx
		mov ebx, [ebp + 12] ; adres b w ebx
		mov ecx, [ebp + 16] ; rozmiar tablic

		mov eax, ecx ; d�ugo�� long long int w bajtach
		mov esi, 8
		mul esi ; d�ugo�� tablicy w bajtach (rozmiar * 8)
		push eax
		call _malloc       ; Alokujemy pami��
		add esp, 4

		mov edi, eax ; adres nowej tablicy
		xor esi, esi ; indeks = 0
		mov edx, [ebp + 8] ; adres a w edx - po raz drugi, bo w poprzedniej operacji zosta� nadpisany (malloc)
		mov ebx, [ebp + 12] ; adres b w ebx
		mov ecx, [ebp + 16] ; rozmiar tablic

	petla:
		; Starsza cz��
		mov eax, [edx + esi * 8] ; eax = a[i]
		push edx
		mov edx, [ebx + esi * 8] ; edx = b[i]
		sub eax, edx ; eax = a[i] - b[i]
		pop edx 
		push edi
		lea edi, [edi + esi * 8] ; edi = &c[i]
		mov [edi], eax ; c[i] = a[i] - b[i]
		pop edi 

		; M�odsza cz�� 
		mov eax, [edx + esi * 8 + 4] ; eax = a[i]
		push edx
		mov edx, [ebx + esi * 8 + 4] ; edx = b[i]
		sbb eax, edx ; sbb - sub with borrow (odejmowanie z przeniesieniem), je�li poprzednia operacja odejmowania wykona�a si� z przeniesieniem, to odejmujemy 1
		pop edx
		push edi
		lea edi, [edi + esi * 8 + 4] ; edi = &c[i]
		mov [edi], eax ; c[i] = a[i] - b[i]
		pop edi

		; Zwi�kszamy licznik i p�tla
		inc esi
		loop petla

		; Zwracamy adres nowej tablicy
		mov eax, edi

		pop edx
		pop edi
		pop esi
		pop ebp
		ret
	_roznica ENDP
END
