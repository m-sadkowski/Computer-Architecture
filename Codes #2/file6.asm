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
    ; £añcuch znaków (data wejœciowa), który bêdzie przetwarzany
	koniec_wejscia db ?       ; Zmienna przechowuj¹ca znak koñca wejœcia
	wynik db 80 dup (?)       ; Bufor wynikowy, w którym zapisany bêdzie wynik
	koniec_wyniku db 10       ; Znak koñca linii (dla wyniku)

.code                        
_main PROC                   
	mov ecx, (OFFSET koniec_wejscia) - (OFFSET wejscie)
	push ecx
	push OFFSET wejscie
	push 1
	call __write
	add esp, 12            

	mov ecx,9                 ; Inicjalizacja ECX do 9 (iloœæ iteracji pêtli)
	mov ebx,2                 ; Ustawienie EBX na 2, aby pomin¹æ pierwszy bajt (niezwi¹zany z dat¹)
	mov edi,0                 ; Ustawienie indeksu dla bufora wynikowego
	mov edx,0                 ; Wyczyszczenie rejestru EDX

ptl:                         
		mov dl, wejscie[ebx]      ; Pobranie pierwszego bajtu liczby z wejœcia
		mov dh, wejscie[ebx+2]    ; Pobranie drugiego bajtu liczby z wejœcia
		cmp dx,3130H              ; Sprawdzenie, czy jest to liczba "10"
		je jeden                  ; Jeœli tak, idŸ do etykiety 'jeden'
		cmp dx,3230H              ; Sprawdzenie, czy jest to liczba "20"
		je dwa                    ; Jeœli tak, idŸ do etykiety 'dwa'
		mov wynik[edi],dl         ; W przeciwnym razie zapisz pierwszy bajt do bufora wynikowego
		jmp dalej                 ; PrzejdŸ do nastêpnej iteracji

		jeden:                    ; Etykieta, gdy liczba to "10"
			mov wynik[edi],'s'      ; Zapisz "styczeñ" do wyniku
			mov wynik[edi+1],'t'
			mov wynik[edi+2],'y'
			mov wynik[edi+3],'c'
			mov wynik[edi+4],'z'
			mov wynik[edi+5],'e'
			mov wynik[edi+6],'n'
			add edi,6               ; Przesuñ wskaŸnik o 6 bajtów
			jmp dalej               ; PrzejdŸ do dalszego przetwarzania

		dwa:                      ; Etykieta, gdy liczba to "20"
			mov wynik[edi],'l'      ; Zapisz "luty" do wyniku
			mov wynik[edi+1],'u'
			mov wynik[edi+2],'t'
			mov wynik[edi+3],'y'
			add edi,3               ; Przesuñ wskaŸnik o 3 bajty
			jmp dalej               ; PrzejdŸ do dalszego przetwarzania

		dalej:                    ; Etykieta dla dalszej iteracji
			add edi,1               ; Zwiêksz wskaŸnik dla wyniku
			add ebx,2               ; Przesuñ wskaŸnik dla wejœcia (pomiñ kolejne dwa bajty)
	dec ecx                    ; Zmniejsz licznik pêtli
	jnz ptl                    ; Jeœli licznik nie jest zerem, wróæ do pocz¹tku pêtli

	push edi                   ; Przekazanie rozmiaru wyniku
	push OFFSET wynik          ; Przekazanie wskaŸnika na bufor wynikowy
	push 1
	; Wywo³anie funkcji __write do wypisania wyniku
	call __write
	add esp, 12                ; Czyszczenie stosu

	push 0                     ; Zakoñczenie procesu
	call _ExitProcess@4
_main ENDP                    ; Koniec funkcji g³ównej

.data                         ; Sekcja danych (pusta)
END                           ; Koniec programu
