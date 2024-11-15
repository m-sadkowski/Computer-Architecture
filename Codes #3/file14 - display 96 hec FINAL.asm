.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC

public _main

.data
	liczba db '12345',0
	w2  dd 0
	w1  dd 0
	w0  dd 0
	_a2 dd 0
	_a1 dd 0
	_a0 dd 0

.code
	wyswietl_96 PROC
		push ebp
		mov ebp, esp
		;parametry wejściowe ecx, edx, eax - 96-bitowa liczba
		sub esp, 24   ; zmienne lokalne
		push ebx
		push esi
		push edi

		mov eax, [ebp+8]   ; część najmłodsza
		mov edx, [ebp+12]  ; część środkowa
		mov ecx, [ebp+16]  ; część najstarsza
		mov w2, ecx
		mov w1, edx
		mov w0, eax

		mov ebx, 10        ; dzielnik
		mov ecx, 0         ; licznik cyfr

	et:
		mov eax, w2        ; wczytaj najstarszą część
		mov _a2, eax
		mov eax, w1        ; wczytaj środkową część
		mov _a1, eax
		mov eax, w0        ; wczytaj najmłodszą część
		mov _a0, eax

		mov edx, 0
		mov eax, _a2       ; podziel najstarszą część
		div ebx
		mov w2, eax

		mov eax, _a1       ; podziel środkową część z resztą z poprzedniej
		div ebx
		mov w1, eax

		mov eax, _a0       ; podziel najmłodszą część z resztą
		div ebx
		mov w0, eax

		add dl, '0'        ; zamień na znak ASCII
		push edx
		inc ecx
		add eax, w2
		jnz et
 
		lea esi, [ebp-24]
	et2:
		pop edx
		mov [esi], dl
		inc esi
		loop et2

		mov [esi], byte ptr 0

		lea ebx, [ebp-24]
		push  4            ; utype
		push ebx
		push ebx
		push  0            ; hwnd
		call _MessageBoxA@16

		mov eax, 1234
		pop edi
		pop esi
		pop ebx
		add esp, 24        ; usuń zmienne lokalne
		pop ebp
		ret
	wyswietl_96 ENDP

	wyswietl_96_hec PROC
		push ebp
		mov ebp, esp
		;parametry wejściowe ecx, edx, eax - 96-bitowa liczba
		sub esp, 24   ; zmienne lokalne
		push ebx
		push esi
		push edi

		mov eax, [ebp+8]   ; część najmłodsza
		mov edx, [ebp+12]  ; część środkowa
		mov ecx, [ebp+16]  ; część najstarsza
		mov w2, ecx
		mov w1, edx
		mov w0, eax

		mov ebx, 16        ; dzielnik dla systemu szesnastkowego
		mov ecx, 0         ; licznik cyfr

	et:
		mov eax, w2        ; wczytaj najstarszą część
		mov _a2, eax
		mov eax, w1        ; wczytaj środkową część
		mov _a1, eax
		mov eax, w0        ; wczytaj najmłodszą część
		mov _a0, eax

		mov edx, 0
		mov eax, _a2       ; podziel najstarszą część
		div ebx
		mov w2, eax

		mov eax, _a1       ; podziel środkową część z resztą z poprzedniej
		div ebx
		mov w1, eax

		mov eax, _a0       ; podziel najmłodszą część z resztą
		div ebx
		mov w0, eax

		; Zamiana reszty na znak szesnastkowy
		add dl, '0'        ; zamień na znak ASCII dla 0-9
		cmp dl, '9'
		jbe _hex_digit
		add dl, 7          ; zamień na A-F

	_hex_digit:
		push edx           ; zapisz znak

		inc ecx            ; inkrementuj licznik cyfr
		add eax, w2
		jnz et

		; Skopiowanie znaków do pamięci
		lea esi, [ebp-24]
	et2:
		pop edx
		mov [esi], dl
		inc esi
		loop et2

		mov [esi], byte ptr 0

		lea ebx, [ebp-24]
		push 4             ; utype
		push ebx
		push ebx
		push 0             ; hwnd
		call _MessageBoxA@16

		mov eax, 1234
		pop edi
		pop esi
		pop ebx
		add esp, 24        ; usuń zmienne lokalne
		pop ebp
		ret
	wyswietl_96_hec ENDP


	_main PROC
		push 0FFFFFFFFh    ; ECX - najstarsza część
		push 0FFFFFFFFh    ; EDX - środkowa część
		push 0FFFFFFFFh    ; EAX - najmłodsza część
		call  wyswietl_96_hec
		add esp, 12

		push 0
		call _ExitProcess@4
	_main ENDP
END
