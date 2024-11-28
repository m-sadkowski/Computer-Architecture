.686
.model flat
public _kwadrat

.code

_kwadrat PROC
		push ebp ; zapisanie rejestru ebp
		mov ebp, esp ; przypisanie ebp do esp
		push ebx ; zapisanie rejestru ebx

		mov eax, [ebp+8] ; pobranie mlodszej czesci liczby
		mov edx, [ebp+12] ; pobranie starszej czesci liczby
		cmp eax, 0
		jne dalej_1

	sprawdz_1:
		cmp edx, 0
		je zwroc_0

	dalej_1:
		cmp eax, 1
		jne dalej_2

	sprawdz_2:
		cmp edx, 0
		je zwroc_1

	dalej_2:
		clc
		rcl eax, 1
		rcl edx, 1
		clc
		rcl eax, 1
		rcl edx, 1

		sub eax, 4
		jnc dalej_3
		sub edx, 1

	dalej_3:
		push edx
		push eax

	zwroc_cos:
		mov eax, [ebp+8]
		mov edx, [ebp+12]
		sub eax, 2
		jnc dalej_5
		sub edx, 1

	dalej_5:
		push edx
		push eax
		call _kwadrat
		add esp, 8
		pop ecx
		add eax, ecx
		jnc dalej_4
		add edx, 1

	dalej_4:
		pop ecx
		add edx, ecx 
		jmp koniec

	zwroc_1:
		mov eax, 1
		jmp koniec

	zwroc_0:
		mov eax, 0
		jmp koniec

	koniec:
		pop ebx
		pop ebp
		ret
	_kwadrat ENDP

END
