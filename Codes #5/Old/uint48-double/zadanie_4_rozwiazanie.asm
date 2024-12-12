.686
.model flat
.xmm

.data
dzielnik dd 10000h

.code
_uint48_float PROC
	push ebp
	mov ebp, esp
	finit

	fild qword ptr [ebp+8]
	fidiv dword ptr dzielnik

	pop ebp
	ret
_uint48_float ENDP

END
