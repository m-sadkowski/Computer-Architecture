.686
.model flat
public _main
extern _ExitProcess@4 : PROC

.code
	_main PROC
		mov edx, 0001000Ah ; czêœæ ca³kowita to bity 31 - 7, czêœæ u³amkowa to bity 6 - 0
		bt edx, 6 ; sprawdzenie bitu 6
		jc doGory ; zaokr¹glenie do gory
		bt edx, 31 ; sprawdzenie znaku
		jc dodaj ; jeœli ujemna to dodaj
		jmp odejmij ; jeœli dodatnia to odejmij

	doGory:
		bt edx, 31 ; sprawdzenie znaku
		jc odejmij ; jeœli ujemna to odejmij

	dodaj:
		add edx, 80h ; dodanie 80h (binarnie 1000 0000 czyli 1 do czêœci ca³kowitej)
		jmp koniec

	odejmij:
		sub edx, 80h ; odjêcie 80h (binarnie 1000 0000 czyli 1 od czêœci ca³kowitej)
		jmp koniec

	koniec:
		and edx, 0FFFFFF80h ; wyzerowanie czêœci u³amkowej (bity 6 - 0))
		push 0
		call _ExitProcess@4
	_main ENDP
END