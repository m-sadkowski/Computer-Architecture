.686
.model flat
.xmm
extern _malloc : PROC
.code 
_single_neuron PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	xor esi, esi

	push 4
	call _malloc
	mov edi, eax
	add esp, 4

	mov eax, [ebp+8]
	mov ebx, [ebp+12]
	mov ecx, [ebp+16]

	fldz
ptl:
	fld qword ptr [eax+esi*8]
	fld dword ptr [ebx+esi*4]
	fmulp
	faddp
	inc esi
	loop ptl

	fldz
	fcomi st(0), st(1)
	jb wrzuc_wynik
	fstp dword ptr [edi]
	fstp st(0)
	jmp koniec

wrzuc_wynik:
	fstp st(0)
	fstp dword ptr [edi]

koniec:
	mov eax, edi

	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_single_neuron ENDP

END
