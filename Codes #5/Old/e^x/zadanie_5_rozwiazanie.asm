.686
.model flat
extern __write : PROC
extern _ExitProcess@4 : PROC

.code

exp PROC
	fldl2e
	fmulp st(1), st(0)
	fst st(1)
	frndint
	fsub st(1), st(0)
	fxch
	f2xm1
	fld1
	faddp st(1), st(0) 
	fscale
	fstp st(1)
	ret
exp ENDP

wyswietl_EAX_dec_with_dot PROC
	pusha

	sub esp, 12
	mov edi, esp
	add edi, 11
	mov ecx, 0
	mov ebx, 10						; dzielnik równy 10

konwersja_dec_with_dot:
	xor edx, edx					; zerowanie starszej części dzielnej
	div ebx							; dzielenie przez 10, reszta w EDX,
									; iloraz w EAX
	add dl, 30H						; zamiana reszty z dzielenia na kod
									; ASCII
	dec edi							; zmniejszenie indeksu
	mov [edi],dl					; zapisanie cyfry w kodzie ASCII
	inc ecx
	or eax, eax						; sprawdzenie czy iloraz = 0
	jne konwersja_dec_with_dot		; skok, gdy iloraz niezerowy

									; wypełnienie pozostałych bajtów spacjami i wpisanie
									; znaków nowego wiersza

wyswietl_dec_with_dot:
	mov esi, edi
	add esi, ecx
	sub esi, 7
	mov dl, '.'
	mov [esi], dl
	mov ebx, [esi]
	ror ebx, 8
	mov [esi], ebx

	mov byte PTR [edi+ecx], 0AH		; kod nowego wiersza
	add ecx, 2
	sub edi, 1
									; wyświetlenie cyfr na ekranie
	push dword PTR ecx				; liczba wyświetlanych znaków
	push dword PTR edi				; adres wyśw. obszaru
	push dword PTR 1				; numer urządzenia (ekran ma numer 1)
	call __write					; wyświetlenie liczby na ekranie
	add esp, 24						; usunięcie parametrów ze stosu


	popa
	ret
wyswietl_EAX_dec_with_dot ENDP

_main PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	finit

	xor edx, edx
	mov ecx, 10

ptl:
	inc edx
	push edx
	fild dword ptr [esp]
	push 10
	fild dword ptr [esp]
	add esp, 8
	fdivp
	call exp
	push 1000
	fild dword ptr [esp]
	add esp, 4
	fmulp
	sub esp, 4
	fist dword ptr [esp]
	mov eax, [esp]
	add esp, 4

	call wyswietl_EAX_dec_with_dot
	loop ptl

	pop edi
	pop esi
	pop ebx
	pop ebp
	
	push 0
	call _ExitProcess@4
_main ENDP

END
