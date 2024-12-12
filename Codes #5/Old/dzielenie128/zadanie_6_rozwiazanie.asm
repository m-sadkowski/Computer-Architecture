.686
.model flat
.xmm

.data
zmienne dw ?, ?, ?, ?

.code
_dziel PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi

	mov ecx, 4
	mov edx, [ebp+16]
	xor ebx, ebx
ptl1:
	mov [ebx*4+OFFSET zmienne], edx
	inc ebx
	loop ptl1

	mov esi, [ebp+8]
	mov ecx, [ebp+12]

ptl2:
	movups xmm5, [esi]
	divps xmm5, xmmword ptr zmienne
	movups [esi], xmm5
	add esi, 16
	loop ptl2


	pop edi
	pop esi
	pop ebx
	pop ebp
	ret
_dziel ENDP

END
