.686
.model flat
extern _ExitProcess@4 : PROC
public _main

.data
x dd 1.0

.code
	_main PROC
		finit

		fld x

		fldl2e ; log 2 e
		fmulp st(1), st(0) ; obliczenie x * log 2 e

		fst st(1) ; kopiowanie obliczonej warto�ci do ST(1)
		
		frndint ; zaokr�glenie do warto�ci ca�kowitej

		fsub st(1), st(0) ; obliczenie cz�ci u�amkowej

		fxch ; zamiana ST(0) i ST(1)
		; po zamianie: ST(0) - cz�� u�amkowa, ST(1) - cz�� ca�kowita

		f2xm1 ; obliczenie warto�ci funkcji wyk�adniczej dla cz�ci u�amkowej wyk�adnika
		fld1 ; liczba 1
		faddp st(1), st(0) ; dodanie 1 do wyniku
		
		fscale ; mno�enie przez 2^(cz�� ca�kowita)
		
		fstp st(1) ; przes�anie wyniku do ST(1) i usuni�cie warto�ci z wierzcho�ka stosu

		; w rezultacie wynik znajduje si� w ST(0)
		push 0
		call _ExitProcess@4
	_main ENDP
END