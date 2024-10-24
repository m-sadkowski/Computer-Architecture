.686                       
.model flat                

extern _ExitProcess@4 : PROC 
extern __write : PROC  
extern __read : PROC  
extern _MessageBoxA@16 : PROC 
extern _MessageBoxW@16 : PROC 

public _main                

.data                  
	wejscie db 10,0,'D',0,'a',0,'t',0,'a',0,' ',0,'1',0,'8',0,'.',0,'0',0,'2',10
    ; �a�cuch znak�w (data wej�ciowa), kt�ry b�dzie przetwarzany
	koniec_wejscia db ?       ; Zmienna przechowuj�ca znak ko�ca wej�cia
	wynik db 80 dup (?)       ; Bufor wynikowy, w kt�rym zapisany b�dzie wynik
	koniec_wyniku db 10       ; Znak ko�ca linii (dla wyniku)

.code                        
_main PROC                   
	mov ecx, (OFFSET koniec_wejscia) - (OFFSET wejscie)
	push ecx
	push OFFSET wejscie
	push 1
	call __write
	add esp, 12            

	mov ecx,9                 ; Inicjalizacja ECX do 9 (ilo�� iteracji p�tli)
	mov ebx,2                 ; Ustawienie EBX na 2, aby pomin�� pierwszy bajt (niezwi�zany z dat�)
	mov edi,0                 ; Ustawienie indeksu dla bufora wynikowego
	mov edx,0                 ; Wyczyszczenie rejestru EDX

ptl:                         
		mov dl, wejscie[ebx]      ; Pobranie pierwszego bajtu liczby z wej�cia
		mov dh, wejscie[ebx+2]    ; Pobranie drugiego bajtu liczby z wej�cia
		cmp dx,3130H              ; Sprawdzenie, czy jest to liczba "10"
		je jeden                  ; Je�li tak, id� do etykiety 'jeden'
		cmp dx,3230H              ; Sprawdzenie, czy jest to liczba "20"
		je dwa                    ; Je�li tak, id� do etykiety 'dwa'
		mov wynik[edi],dl         ; W przeciwnym razie zapisz pierwszy bajt do bufora wynikowego
		jmp dalej                 ; Przejd� do nast�pnej iteracji

		jeden:                    ; Etykieta, gdy liczba to "10"
			mov wynik[edi],'s'      ; Zapisz "stycze�" do wyniku
			mov wynik[edi+1],'t'
			mov wynik[edi+2],'y'
			mov wynik[edi+3],'c'
			mov wynik[edi+4],'z'
			mov wynik[edi+5],'e'
			mov wynik[edi+6],'n'
			add edi,6               ; Przesu� wska�nik o 6 bajt�w
			jmp dalej               ; Przejd� do dalszego przetwarzania

		dwa:                      ; Etykieta, gdy liczba to "20"
			mov wynik[edi],'l'      ; Zapisz "luty" do wyniku
			mov wynik[edi+1],'u'
			mov wynik[edi+2],'t'
			mov wynik[edi+3],'y'
			add edi,3               ; Przesu� wska�nik o 3 bajty
			jmp dalej               ; Przejd� do dalszego przetwarzania

		dalej:                    ; Etykieta dla dalszej iteracji
			add edi,1               ; Zwi�ksz wska�nik dla wyniku
			add ebx,2               ; Przesu� wska�nik dla wej�cia (pomi� kolejne dwa bajty)
	dec ecx                    ; Zmniejsz licznik p�tli
	jnz ptl                    ; Je�li licznik nie jest zerem, wr�� do pocz�tku p�tli

	push edi                   ; Przekazanie rozmiaru wyniku
	push OFFSET wynik          ; Przekazanie wska�nika na bufor wynikowy
	push 1
	; Wywo�anie funkcji __write do wypisania wyniku
	call __write
	add esp, 12                ; Czyszczenie stosu

	push 0                     ; Zako�czenie procesu
	call _ExitProcess@4
_main ENDP                    ; Koniec funkcji g��wnej

.data                         ; Sekcja danych (pusta)
END                           ; Koniec programu
