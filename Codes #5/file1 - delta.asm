.686
.model flat
extern _ExitProcess@4 : PROC
public _main

.data
; 2x^2 - x - 15 = 0
wsp_a dd +2.0
wsp_b dd -1.0
wsp_c dd -15.0
dwa dd 2.0
cztery dd 4.0
x1 dd ?
x2 dd ?

.code
	_main PROC
		finit
		fld wsp_a ; za³adowanie wspó³czynnika a
		fld wsp_b ; za³adowanie wspó³czynnika b
		fst st(2) ; kopiowanie b

		; sytuacja na stosie: ST(0) = b, ST(1) = a, ST(2) = b
		fmul st(0),st(0) ; obliczenie b^2

		; sytuacja na stosie: ST(0) = b^2, ST(1) = a, ST(2) = b
		fld cztery

		; sytuacja na stosie: ST(0) = 4.0, ST(1) = b^2, ST(2) = a, ST(3) = b
		fmul st(0), st(2) ; obliczenie 4 * a

		; sytuacja na stosie: ST(0) = 4.0 * a, ST(1) = b^2, ST(2) = a, ST(3) = b
		fmul wsp_c ; obliczenie 4 * a * c

		; sytuacja na stosie: ST(0) = 4.0 * a * c, ST(1) = b^2, ST(2) = a, ST(3) = b
		fsubp st(1), st(0) ; obliczenie b^2 - 4 * a * c

		; sytuacja na stosie: ST(0) = b^2 - 4.0 * a * c, ST(1) = a, ST(2) = b
		fldz ; zaladowanie 0

		; sytuacja na stosie: ST(0) = 0, ST(1) = b^2 - 4 * a * c, ST(2) = a, ST(3) = b
		; rozkaz FCOMI - oba porównywane operandy musza byæ podane na
		; stosie koprocesora
		fcomi st(0), st(1)
		; usuniecie zera z wierzcho³ka stosu
		fstp st(0)
		ja delta_ujemna ; skok, gdy delta ujemna
		; w przyk³adzie nie wyodrêbnia siê przypadku delta = 0

		; sytuacja na stosie: ST(0) = b^2 - 4 * a * c, ST(1) = a, ST(2) = b
		fxch st(1) ; zamiana st(0) i st(1)

		; sytuacja na stosie: ST(0) = a, ST(1) = b^2 - 4 * a * c, ST(2) = b
		fadd st(0), st(0) ; ; obliczenie 2 * a

		; sytuacja na stosie: ST(0) = 2a, ST(1) = b^2 - 4 * a * c, ST(2) = b
		fstp st(3)

		; sytuacja na stosie: ST(0) = b^2 - 4 * a * c, ST(1) = b, ST(2) = 2 * a
		fsqrt ; pierwiastek z delty

		; sytuacja na stosie: ST(0) = sqrt(b^2 - 4 * a * c), ST(1) = b, ST(2) = 2 * a
		; przechowanie obliczonej wartoœci
		fst st(3)

		; sytuacja na stosie: ST(0) = sqrt(b^2 - 4 * a * c), ST(1) = b, ST(2) = 2 * a, ST(3) = sqrt(b^2 - 4 * a * c)
		fchs ; zmiana znaku

		; sytuacja na stosie: ST(0) = -sqrt(b^2 - 4 * a * c), ST(1) = b, ST(2) = 2 * a, ST(3) = sqrt(b^2 - 4 * a * c)
		fsub st(0), st(1); obliczenie -b - sqrt(delta)
		fdiv st(0), st(2); obliczenie x1
		fstp x1 ; zapisanie x1 w pamiêci

		; sytuacja na stosie: ST(0) = b, ST(1) = 2 * a, ST(2) = sqrt(b^2 - 4 * a * c)
		fchs ; zmiana znaku
		fadd st(0), st(2) ; obliczenie -b - sqrt(delta)
		fdiv st(0), st(1) ; obliczenie x2
		fstp x2 ; zapisanie x1 w pamiêci
	delta_ujemna:
		fstp st(0) ; oczyszczenie stosu
		fstp st(0) ; oczyszczenie stosu

		push 0
		call _ExitProcess@4
	_main ENDP
END