.686
.model flat
public _suma

COMMENT | .code
	_suma PROC
		push ebp
		mov ebp, esp 
		push esi 
		push ecx

		mov esi, [ebp + 8] ; adres tablicy
		mov ecx, [ebp + 12] ; n

		cmp ecx, 0
		jbe koniec

		; do edx i eax wpisujemy biezacy element z tablicy
		mov edx, [esi + 4] ; starsza czêœæ
		mov eax, [esi] ; m³odsza czêœæ

		; dodajemy nastepny element z tablicy
		add [esi + 8], eax
		adc [esi + 12], edx

		add esi, 8 ; przesuwamy indeks na nastepny element z tablicy
		dec ecx ; zmniejszamy ilosc elementow

		; wywolanie rekurencyjne dla n - 1 elementow od nastepnego elementu tablicy
		push ecx
		push esi
		call _suma
		add esp, 8

	koniec:
		pop ecx
		pop esi
		pop ebp
		ret 
	_suma ENDP
END |

.code
	_suma PROC
		push ebp
		mov ebp, esp

		mov ecx, [ebp + 12] ; w ecx mamy n
		cmp ecx, 0
		jz koniec_rek ; jesli n = 0 to koniec rekurencji

		mov esi, [ebp + 8] ; w esi mamy adres tablicy
		add esi, 8 ; przesuwamy sie na nastepny element tablicy
		dec ecx ; zmniejszamy ilosc elementow

		push ecx ; zapisujemy n - 1
		push esi ; zapisujemy adres tablicy
		call _suma 
		add esp, 8 

		mov esi, [ebp + 8] ; w esi mamy adres tablicy
		add eax, [esi] ; do eax dodajemy m³odsza czêœæ liczby
		adc edx, [esi + 4] ; do edx dodajemy starsza czêœæ liczby
		jmp koniec

	koniec_rek:
		xor eax, eax ; zerujemy eax
		xor edx, edx ; zerujemy edx

	koniec:
		pop ebp
		ret
	_suma ENDP
END




