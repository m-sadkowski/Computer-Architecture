.686
.model flat
extern _ExitProcess@4 : PROC
public _main

.code
	_main PROC
		mov eax, 00000080h ; binarnie 00000000 00000000 00000000 10000000
		mov ecx, 25
	petla: 
		shl eax, 1
		jc jest_1
		loop petla

		clc
		jmp koniec
	jest_1:
		stc

	koniec:
		push 0
		call _ExitProcess@4 
	_main ENDP
END
