; Przyk³ad wywo³ywania funkcji MessageBoxA i MessageBoxW
.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC
public _main
.data
tytul_Unicode dw 'Z','w','i','e','r','z',0119H,'t','a',0
tekst_Unicode dw 'T','o',' ','j','e','s','t',' ','p','i','e'
dw 's',' ',0D83Dh, 0DC15h,' ','i',' ','k','o','t', ' '
dw 0D83Dh, 0DC08h

.code
	_main PROC
		push 0 ; stala MB_OK
		; adres obszaru zawieraj¹cego tytu³
		push OFFSET tytul_Unicode
		; adres obszaru zawieraj¹cego tekst
		push OFFSET tekst_Unicode
		push 0 ; NULL
		call _MessageBoxW@16
		push 0 ; kod powrotu programu
		call _ExitProcess@4

	_main ENDP
END
