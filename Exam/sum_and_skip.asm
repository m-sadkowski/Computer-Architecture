.686
.model flat

extern _ExitProcess@4 : PROC
extern __write : PROC

public _main
public _sum_and_skip

.data
	obszar db 12 dup (?)
	dekoder db '0123456789ABCDEF'

.code
	wyswietl_EAX_hex PROC
		; wyœwietlanie zawartoœci rejestru EAX
		; w postaci liczby szesnastkowej
		pusha ; przechowanie rejestrów

		; rezerwacja 12 bajtów na stosie (poprzez zmniejszenie
		; rejestru ESP) przeznaczonych na tymczasowe przechowanie
		; cyfr szesnastkowych wyœwietlanej liczby
		sub esp, 12
		mov edi, esp ; adres zarezerwowanego obszaru
		; pamiêci
		; przygotowanie konwersji
		mov ecx, 8 ; liczba obiegów pêtli konwersji
		mov esi, 1 ; indeks pocz¹tkowy u¿ywany przy
		; zapisie cyfr
		; pêtla konwersji
		ptl3hex:
		; przesuniêcie cykliczne (obrót) rejestru EAX o 4 bity w lewo
		; w szczególnoœci, w pierwszym obiegu pêtli bity nr 31 - 28
		; rejestru EAX zostan¹ przesuniête na pozycje 3 - 0
		rol eax, 4
		; wyodrêbnienie 4 najm³odszych bitów i odczytanie z tablicy
		; 'dekoder' odpowiadaj¹cej im cyfry w zapisie szesnastkowym
		mov ebx, eax ; kopiowanie EAX do EBX
		and ebx, 0000000FH ; zerowanie bitów 31 - 4 rej.EBX

		mov dl, dekoder[ebx] ; pobranie cyfry z tablicy
		; przes³anie cyfry do obszaru roboczego
		mov [edi][esi], dl
		inc esi ;inkrementacja modyfikatora
		loop ptl3hex ; sterowanie pêtl¹

		; wpisanie znaku nowego wiersza przed i po cyfrach
		mov byte PTR [edi][0], 10
		mov byte PTR [edi][9], 10

		; zamiana zer na spacje
		mov ecx, 10 ; liczba obiegów pêtli
		mov esi, 1 ; indeks pocz¹tkowy
	ptlzera:
		cmp byte PTR [edi][esi], 30H ; sprawdzenie czy cyfra to 0
		je byl_zero ; skok, gdy napotkano 0
		jmp koniec_zer
	byl_zero:
		mov byte PTR [edi][esi], 20H ; zamiana 0 na spacjê
		inc esi ; inkrementacja indeksu
		loop ptlzera ; sterowanie pêtl¹
	koniec_zer:

		; wyœwietlenie przygotowanych cyfr
		push 10 ; 8 cyfr + 2 znaki nowego wiersza
		push edi ; adres obszaru roboczego
		push 1 ; nr urz¹dzenia (tu: ekran)
		call __write ; wyœwietlenie
		; usuniêcie ze stosu 24 bajtów, w tym 12 bajtów zapisanych
		; przez 3 rozkazy push przed rozkazem call
		; i 12 bajtów zarezerwowanych na pocz¹tku podprogramu
		add esp, 24

		popa ; odtworzenie rejestrów
		ret ; powrót z podprogramu
	wyswietl_EAX_hex ENDP
	
	_sum_and_skip PROC
		push ebx
		mov ebx, [esp + 4]
		mov ax, word ptr [ebx]
		add ax, word ptr [ebx + 2]
		pop ebx
		add dword ptr [esp], 4
		ret
	_sum_and_skip ENDP

	_main PROC
		xor eax, eax
		call _sum_and_skip 
		dw 23h
		dw 43h
		nop
		call wyswietl_EAX_hex
		push 0
		call _ExitProcess@4
	_main ENDP
END


