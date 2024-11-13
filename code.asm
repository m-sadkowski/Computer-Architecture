; Program zawiera wszystkie funkcje do wczytywania i wyswietlania rejestru EAX

.686
.model flat
extern __write : PROC
extern __read : PROC
extern _ExitProcess@4 : PROC

public _main

.data
	obszar db 12 dup (?) ; deklaracja tablicy do przechowywania wprowadzanych cyfr
	dziesiec dd 10 ; mnożnik
	dekoder db '0123456789ABCDEF' ; tablica do konwersji na postać szesnastkową

.code
	

	_main PROC
		; call nazwa_funkcji (wczytaj)
		; call nazwa_funkcji (wyswietl)

		push 0
		call _ExitProcess@4
	_main ENDP

END

