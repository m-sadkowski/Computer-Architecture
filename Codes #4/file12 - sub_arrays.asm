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

		mov eax, ecx ; d³ugoœæ long long int w bajtach
		mov esi, 8
		mul esi ; d³ugoœæ tablicy w bajtach (rozmiar * 8)
		push eax
		call _malloc       ; Alokujemy pamiêæ
		add esp, 4

		mov edi, eax ; adres nowej tablicy
		xor esi, esi ; indeks = 0
		mov edx, [ebp + 8] ; adres a w edx - po raz drugi, bo w poprzedniej operacji zosta³ nadpisany (malloc)
		mov ebx, [ebp + 12] ; adres b w ebx
		mov ecx, [ebp + 16] ; rozmiar tablic

	petla:
		; Starsza czêœæ
		mov eax, [edx + esi * 8] ; eax = a[i]
		push edx
		mov edx, [ebx + esi * 8] ; edx = b[i]
		sub eax, edx ; eax = a[i] - b[i]
		pop edx 
		push edi
		lea edi, [edi + esi * 8] ; edi = &c[i]
		mov [edi], eax ; c[i] = a[i] - b[i]
		pop edi 

		; M³odsza czêœæ 
		mov eax, [edx + esi * 8 + 4] ; eax = a[i]
		push edx
		mov edx, [ebx + esi * 8 + 4] ; edx = b[i]
		sbb eax, edx ; sbb - sub with borrow (odejmowanie z przeniesieniem), jeœli poprzednia operacja odejmowania wykona³a siê z przeniesieniem, to odejmujemy 1
		pop edx
		push edi
		lea edi, [edi + esi * 8 + 4] ; edi = &c[i]
		mov [edi], eax ; c[i] = a[i] - b[i]
		pop edi

		; Zwiêkszamy licznik i pêtla
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
