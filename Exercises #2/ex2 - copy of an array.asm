.686
.model flat
extern _malloc : PROC
public _kopia_tablicy

.code
	_kopia_tablicy PROC
		push ebp
		mov ebp, esp

		push esi
		push ecx
		push ebx

		mov ecx, [ebp + 12] ; ilosc elementow
		imul ecx, 4 ; int jest na 4 bajtach
		push ecx
		call _malloc ; EAX wskazuje na miejsce w pamieci z nowa tablica
		add esp, 4

		mov esi, [ebp + 8] ; adres pierwszej tablicy
		mov ecx, [ebp+12] ; ilosc elementow
		mov ebx, 0 ; iterator na obie tablice

		; ESI - wskazuje na pierwsza tablice
		; EAX - wskazuje na nowa tablice
		; EBX - iterator do obu tablic
		; ECX - ilosc elementow
		
	petla:
		mov edx, [esi + 4 * ebx] ; do EDX pobieramy kolejne elementy z oryginalnej tablicy
		bt edx, 0 ; sprawdzamy czy liczba jest parzysta (ostatni bit = 0?)
		jc nieparzysta
		mov [eax + 4 * ebx], edx
		inc ebx
		loop petla
		jmp koniec

	nieparzysta:
		mov edx, 0
		mov [eax + 4 * ebx], edx
		inc ebx
		loop petla

	koniec:
		pop ebx
		pop ecx
		pop esi
		pop ebp
		ret

	_kopia_tablicy ENDP
END