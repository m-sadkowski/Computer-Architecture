.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC 
public _main

.data
	wynik db 80 dup (?)
	nowa_linia db 10 
	tytul db 10, 'Wynik', 0 

.code
	_main PROC

		mov ax, 15		; Dzielna (10) do AX (16-bitowy rejestr)

		mov bl, 3		; Dzielnik (5) do BL (8-bitowy rejestr)
		div bl			; Dzielenie: AL = AX / BL, AH = reszta 

		add al, 30h		; Zamiana na znak ASCII 

		mov wynik, al   

		push 0
		push OFFSET tytul
		push OFFSET wynik
		push 0
		call _MessageBoxA@16 
		add esp, 16

		call _ExitProcess@4
	_main ENDP
END