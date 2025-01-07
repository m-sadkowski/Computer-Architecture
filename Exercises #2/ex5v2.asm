.686
.model flat
public _szyfruj

.code
	_szyfruj PROC
		push ebp
		mov ebp, esp

		push esi
		push edi
		push ebx
		push ecx
		push edx

		mov eax, [ebp + 8] ; adres tekstu
		mov esi, -1 ; d�ugo�� tekstu
	ileZnakow:
		inc esi
		mov dl, [eax][esi]
		cmp dl, 0
		jne ileZnakow

		; w esi d�ugo�� tekstu
		mov edi, 0 ; iterator do tekstu
		mov ebx, 52525252H ; pierwsza liczba losowa

	szyfrowanie:
		mov dl, [eax + edi] ; znak z tekstu
		xor dl, bl ; operacja szyfruj�ca znak
		mov [eax + edi], dl ; zapisanie zaszyfrowanego znaku

		; wyznaczenie kolejnej liczby losowej
		mov ecx, 80000000H ; bit nr 31
		and ecx, ebx ; w ecx bit nr 31
		mov edx, 40000000H ; bit nr 30
		and edx, ebx ; w edx bit nr 30
		xor ecx, edx ; suma modulo 2 bit�w nr 31 i 30 w ecx

		rol ebx, 1 ; przesuni�cie o 1 w lewo
		
		shr ecx, 31
		or ebx, ecx

		; nast�pny obieg p�tli
		inc edi
		cmp edi, esi
		jne szyfrowanie

		pop edx
		pop ecx
		pop ebx
		pop edi
		pop esi

		pop ebp
		ret
	_szyfruj ENDP
END