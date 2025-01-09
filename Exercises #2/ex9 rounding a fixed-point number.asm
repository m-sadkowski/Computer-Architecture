.686
.model flat
public _main
extern _ExitProcess@4 : PROC

.code
	_main PROC
		mov edx, 0001000Ah ; cz�� ca�kowita to bity 31 - 7, cz�� u�amkowa to bity 6 - 0
		bt edx, 6 ; sprawdzenie bitu 6
		jc doGory ; zaokr�glenie do gory
		bt edx, 31 ; sprawdzenie znaku
		jc dodaj ; je�li ujemna to dodaj
		jmp odejmij ; je�li dodatnia to odejmij

	doGory:
		bt edx, 31 ; sprawdzenie znaku
		jc odejmij ; je�li ujemna to odejmij

	dodaj:
		add edx, 80h ; dodanie 80h (binarnie 1000 0000 czyli 1 do cz�ci ca�kowitej)
		jmp koniec

	odejmij:
		sub edx, 80h ; odj�cie 80h (binarnie 1000 0000 czyli 1 od cz�ci ca�kowitej)
		jmp koniec

	koniec:
		and edx, 0FFFFFF80h ; wyzerowanie cz�ci u�amkowej (bity 6 - 0))
		push 0
		call _ExitProcess@4
	_main ENDP
END