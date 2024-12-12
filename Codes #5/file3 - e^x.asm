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

		fst st(1) ; kopiowanie obliczonej wartoœci do ST(1)
		
		frndint ; zaokr¹glenie do wartoœci ca³kowitej

		fsub st(1), st(0) ; obliczenie czêœci u³amkowej

		fxch ; zamiana ST(0) i ST(1)
		; po zamianie: ST(0) - czêœæ u³amkowa, ST(1) - czêœæ ca³kowita

		f2xm1 ; obliczenie wartoœci funkcji wyk³adniczej dla czêœci u³amkowej wyk³adnika
		fld1 ; liczba 1
		faddp st(1), st(0) ; dodanie 1 do wyniku
		
		fscale ; mno¿enie przez 2^(czêœæ ca³kowita)
		
		fstp st(1) ; przes³anie wyniku do ST(1) i usuniêcie wartoœci z wierzcho³ka stosu

		; w rezultacie wynik znajduje siê w ST(0)
		push 0
		call _ExitProcess@4
	_main ENDP
END