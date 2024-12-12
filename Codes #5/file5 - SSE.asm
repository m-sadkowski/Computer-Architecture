; Program przyk�adowy ilustruj�cy operacje SSE procesora
; Poni�szy podprogram jest przystosowany do wywo�ywania
; z poziomu j�zyka C (program arytmc_SSE.c)
.686
.XMM ; zezwolenie na asemblacj� rozkaz�w grupy SSE
.model flat
public _dodaj_SSE, _pierwiastek_SSE, _odwrotnosc_SSE, _dodaj_SSE_16, _int2float, _pm_jeden

.data
tab dd 1.0, 1.0, 1.0, 1.0

.code
	_dodaj_SSE PROC
		push ebp
		mov ebp, esp
		push ebx
		push esi
		push edi
		mov esi, [ebp+8] ; adres pierwszej tablicy
		mov edi, [ebp+12] ; adres drugiej tablicy
		mov ebx, [ebp+16] ; adres tablicy wynikowej

		; �adowanie do rejestru xmm5 czterech liczb zmiennoprzecinkowych 32-bitowych - liczby zostaj� pobrane z tablicy, 
		; kt�rej adres poczatkowy podany jest w rejestrze ESI

		; interpretacja mnemonika "movups" :
		; mov - operacja przes�ania,
		; u - unaligned (adres obszaru nie jest podzielny przez 16),
		; p - packed (do rejestru �adowane s� od razu cztery liczby),
		; s - short (inaczej float, liczby zmiennoprzecinkowe 32-bitowe)

		movups xmm5, [esi]
		movups xmm6, [edi]

		; sumowanie czterech liczb zmiennoprzecinkowych zawartych w rejestrach xmm5 i xmm6
		addps xmm5, xmm6

		; zapisanie wyniku sumowania w tablicy w pami�ci
		movups [ebx], xmm5
		pop edi
		pop esi
		pop ebx
		pop ebp
		ret
	_dodaj_SSE ENDP

	_pierwiastek_SSE PROC
		push ebp
		mov ebp, esp
		push ebx
		push esi
		mov esi, [ebp+8] ; adres pierwszej tablicy
		mov ebx, [ebp+12] ; adres tablicy wynikowej
		; �adowanie do rejestru xmm5 czterech liczb zmiennoprzecinkowych 32-bitowych - liczby zostaj� pobrane z tablicy, 
		; kt�rej adres pocz�tkowy podany jest w rejestrze ESI

		 movups xmm6, [esi]

		; obliczanie pierwiastka z czterech liczb zmiennoprzecinkowych znajduj�cych sie w rejestrze xmm6 - wynik wpisywany jest do xmm5
		 sqrtps xmm5, xmm6

		; zapisanie wyniku sumowania w tablicy w pami�ci
		 movups [ebx], xmm5
		 pop esi
		 pop ebx
		 pop ebp
		 ret
	_pierwiastek_SSE ENDP

	; rozkaz RCPPS wykonuje obliczenia na 12-bitowej mantysie (a nie na typowej 24-bitowej) - obliczenia wykonywane s� szybciej, ale s� mniej dok�adne
	_odwrotnosc_SSE PROC
		 push ebp
		 mov ebp, esp
		 push ebx
		 push esi
		 mov esi, [ebp+8] ; adres pierwszej tablicy
		 mov ebx, [ebp+12] ; adres tablicy wynikowej
		; ladowanie do rejestru xmm5 czterech liczb zmiennoprzecinkowych 32-bitowych - liczby zostaj� pobrane z tablicy, 
		; kt�rej adres poczatkowy podany jest w rejestrze ESI

		 movups xmm5, [esi]

		; obliczanie odwrotno�ci czterech liczb zmiennoprzecinkowych znajduj�cych si� w rejestrze xmm6 - wynik wpisywany jest do xmm5
		 rcpps xmm5, xmm6

		; zapisanie wyniku sumowania w tablicy w pamieci
		 movups [ebx], xmm5
		 pop esi
		 pop ebx
		 pop ebp
		 ret
	_odwrotnosc_SSE ENDP

	_dodaj_SSE_16 PROC
		push ebp
		mov ebp, esp
		push ebx
		push esi
		push edi
		mov esi, [ebp+8] ; adres pierwszej tablicy
		mov edi, [ebp+12] ; adres drugiej tablicy
		mov ebx, [ebp+16] ; adres tablicy wynikowej

		; �adowanie do rejestru xmm5 czterech liczb zmiennoprzecinkowych 8-bitowych ze znakiem - liczby zostaj� pobrane z tablicy, 
		; kt�rej adres poczatkowy podany jest w rejestrze ESI

		movups xmm5, [esi]
		movups xmm6, [edi]

		; sumowanie szesnastu liczb zmiennoprzecinkowych zawartych w rejestrach xmm5 i xmm6
		paddsb xmm5, xmm6

		; zapisanie wyniku sumowania w tablicy w pami�ci
		movups [ebx], xmm5
		pop edi
		pop esi
		pop ebx
		pop ebp
		ret
	_dodaj_SSE_16 ENDP

	_int2float PROC
		 push ebp
		 mov ebp, esp
		 push ebx
		 push esi
		 mov esi, [ebp+8] ; adres pierwszej tablicy
		 mov ebx, [ebp+12] ; adres tablicy wynikowej
		; ladowanie do rejestru xmm5 int�w

		 movups xmm5, [esi]

		; zamiana 2 int�w na 2 floaty
		 cvtpi2ps xmm5, qword PTR [esi]

		 movups [ebx], xmm5
		 pop esi
		 pop ebx
		 pop ebp
		 ret
	_int2float ENDP

	_pm_jeden PROC
		push ebp
		mov ebp, esp
		push ebx
		push esi
		push edi
		mov esi, [ebp+8] ; adres tablicy

		movups xmm5, [esi]
		movups xmm4, [tab]

		addsubps xmm5, xmm4

		movups [esi], xmm5

		pop edi
		pop esi
		pop ebx
		pop ebp
		ret
	_pm_jeden ENDP

END
