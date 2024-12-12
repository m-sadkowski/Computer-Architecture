.686
.model flat
.xmm
public _objetosc_stozka, _mul_at_once
.data
BIGR dd ?
SMALLR dd ?
WYS dd ?
.code
_objetosc_stozka PROC
push ebp
mov ebp, esp
push edi
push esi
push ebx

mov eax, [ebp + 8]
mov dword ptr BIGR, eax
mov eax, [ebp + 12]
mov SMALLR, eax
mov eax, [ebp + 16]
mov WYS, eax

fild dword ptr BIGR
fild dword ptr BIGR
fmulp
fild dword ptr BIGR
fild dword ptr SMALLR
fmulp
fild dword ptr SMALLR
fild dword ptr SMALLR
fmulp
faddp
faddp
fld dword ptr WYS
fldpi
fld1
push 3
fild dword ptr [esp]
add esp, 4
fdivp
fmulp
fmulp
fmulp

pop ebx
pop esi
pop edi
pop ebp
ret
_objetosc_stozka ENDP

_mul_at_once PROC
push ebp
mov ebp, esp
push edi
push esi
push ebx

PMULLD xmm0, xmm1

pop ebx
pop esi
pop edi
pop ebp
ret
_mul_at_once ENDP
END