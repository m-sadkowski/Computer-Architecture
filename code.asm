.686
.model flat
public _multiplyfloats
extern _MulDiv@12 : PROC


.code
	_multiplyfloats PROC
		push ebp
		mov ebp, esp

		call _MulDiv@12 
		add esp, 12

		pop ebp
		ret
	_multiplyfloats ENDP
END