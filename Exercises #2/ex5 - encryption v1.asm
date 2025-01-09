.686
.model flat
public _szyfruj

.code
	_szyfruj PROC
		push ebp
		mov ebp, esp

		push ecx
		push ebx
		push edx
		push eax
		push edi

		mov edx, 52525252H ; pierwsza liczba losowa
		mov esi, [ebp + 8] ; adres tekstu
		mov ebx, 0 ; iterator do tekstu
		mov ecx, -1 ; d�ugo�� tekstu
	ileZnakow:
		inc ecx
		mov al, [esi][ecx]
		cmp al, 0
		jne ileZnakow

		; w ecx d�ugo�� tekstu
		; w ebx iterator tekstu
		; w eax adres tekstu
		; w edx liczba losowa

	szyfrowanie:
		mov al, [esi + ebx] ; znak z tekstu
		xor al, dl ; operacja szyfruj�ca znak
		mov [esi + ebx], al ; zapisanie zaszyfrowanego znaku

		; wyznaczenie kolejnej liczby losowej
		mov eax, 80000000H ; bit nr 31
		and eax, edx ; w eax bit nr 31
		mov edi, 40000000H ; bit nr 30
		and edi, edx ; w edi bit nr 30
		
		rol edi, 1 ; przesuni�cie o 1 w lewo
		xor eax, edi ; suma modulo 2 bit�w nr 31 i 30 w eax
		bt eax, 31 ; sprawdzenie bitu nr 31
		rcl edx, 1 ; je�li w eax jest 1 to przesuni�cie w lewo o 1 bit, np. 1010 -> 0101

		; nast�pny obieg p�tli
		inc ebx
		cmp ebx, ecx
		jne szyfrowanie

		pop edi
		pop eax
		pop edx
		pop ebx
		pop ecx

		pop ebp
		ret
	_szyfruj ENDP
END