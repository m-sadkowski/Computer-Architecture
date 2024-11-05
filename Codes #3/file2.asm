.686
.model flat
extern _ExitProcess@4 : PROC
extern _MessageBoxA@16 : PROC 
public _main

.data
	wynik db 80 dup (?)
	nowa_linia db 10 
	tytul db 10, 'Wynik', 0 

.code
	_main PROC

		mov edx, 0		; Starsza czÍúÊ dzielnej (0) do EAX (32-bitowy rejestr)
		mov eax, 42		; M≥odsza czÍúÊ dzielnej (42) do EAX (32-bitowy rejestr) -> (64-bitowy rejestr EDX:EAX z liczbπ 0 42)

		mov ebx, 6		; Dzielnik (6) do EBX (32-bitowy rejestr)
		div ebx			; Dzielenie: EAX = EDX:EAX / EBX, EDX = reszta 

		; Konwersja liczby w EAX na ASCII
		mov ecx, 10       ; Baza dziesiÍtna
		lea edi, wynik    ; Ustawienie wskaünika na wynik
		add edi, 79       ; PrzesuniÍcie wskaünika na koniec bufora (rezerwa na zapis liczby od ty≥u)
		mov byte ptr [edi], 0 ; ZakoÒczenie ciπgu zerem (terminator)

	konwersja_petla:
		xor edx, edx      ; Wyzerowanie EDX (potrzebne do div)
		div ecx           ; EAX / 10, wynik w EAX, reszta w EDX
		add dl, '0'       ; Zamiana reszty na znak ASCII
		dec edi           ; PrzesuniÍcie wskaünika w lewo
		mov [edi], dl     ; Zapisanie znaku do bufora
		test eax, eax     ; Sprawdzenie, czy wynik to 0
		jnz konwersja_petla ; Kontynuacja, jeúli nie

		; Wywo≥anie MessageBox z poprawnym wskaünikiem na wynik
		push 0
		push OFFSET tytul
		push edi          ; Uøycie wskaünika na poczπtek liczby w buforze
		push 0
		call _MessageBoxA@16 
		add esp, 16

		call _ExitProcess@4
	_main ENDP
END