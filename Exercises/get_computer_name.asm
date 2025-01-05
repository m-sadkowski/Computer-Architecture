.686
.model flat
extern _GetComputerNameA@8 : proc
extern __write : proc
extern _ExitProcess@4 : proc

public _main

.data
nazwa db 80 dup ('?')
rozmiar dd 80

.code
	_main PROC
		push dword PTR offset rozmiar
		push dword PTR offset nazwa
		call _GetComputerNameA@8
		add esp, 8

		push rozmiar
		push dword PTR offset nazwa
		push dword PTR 1
		call __write
		add esp, 12

		push 0
		call _ExitProcess@4

	_main ENDP
END


