.686
.model flat

.code
	suma_liczb PROC stdcall, arg1:dword, arg2:dword, arg3:dword
		mov eax, arg1
		add eax, arg2
		add eax, arg3
		ret
	suma_liczb ENDP
END