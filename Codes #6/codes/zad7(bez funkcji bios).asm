.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy

	wyswietl_AL PROC
		; Wyświetlanie zawartości rejestru AL na ekranie
		; Zmienna dnia, miesiąca i roku są pobierane z CS i wyświetlane na ekranie w pamięci ES
		
		push ax   ; Zachowanie wartości rejestrów na stosie
		push cx
		push dx

		in al, 60h   ; Pobranie kodu klawisza z portu klawiatury
		cmp al, 29   ; Sprawdzenie, czy wciśnięto klawisz ESC
		jne dalej    ; Jeśli nie, kontynuuj
		add cs:day, 1 ; Zwiększenie wartości dnia o 1

	dalej:
		mov al, cs:day   ; Pobranie wartości dnia
		mov bx,70        ; Ustawienie adresu w pamięci ekranu
		mov cl, 10       ; Ustawienie dzielnika dla konwersji do ASCII
		mov ah, 0        ; Zerowanie starszej części dzielnej
		
		div cl           ; Dzielenie wartości dnia przez 10, reszta w AH (cyfra jedności), iloraz w AL
		add ah, 30H      ; Konwersja cyfry jedności na kod ASCII
		mov es:[bx+4], ah ; Zapisanie cyfry jedności w pamięci ekranu
		
		mov ah, 0        ; Zerowanie starszej części dzielnej
		div cl           ; Dzielenie przez 10
		add ah, 30H      ; Konwersja cyfry dziesiątek na kod ASCII
		mov es:[bx+2], ah ; Zapisanie cyfry dziesiątek w pamięci ekranu
		add al, 30H      ; Konwersja ilorazu na kod ASCII

		; Ustawienie koloru dla wyświetlanego dnia
		mov al, 00001111B  ; Kolor: jasny biały
		mov es:[bx+3],al  ; Zapisanie koloru dla cyfr
		mov es:[bx+5],al

		; Wyświetlenie miesiąca
		mov al, cs:month  ; Pobranie wartości miesiąca
		mov bx,76         ; Adresowanie pamięci ekranu dla miesiąca
		mov ah, 0         ; Zerowanie starszej części dzielnej
		
		div cl           ; Dzielenie miesiąca przez 10
		add ah, 30H      ; Konwersja cyfry jedności na kod ASCII
		mov es:[bx+4], ah ; Zapisanie cyfry jedności w pamięci ekranu
		
		mov ah, 0        ; Zerowanie starszej części dzielnej
		div cl           ; Dzielenie przez 10
		add ah, 30H      ; Konwersja cyfry dziesiątek na kod ASCII
		mov es:[bx+2], ah ; Zapisanie cyfry dziesiątek w pamięci ekranu
		add al, 30H      ; Konwersja ilorazu na kod ASCII
		mov es:[bx+0], al ; Zapisanie setek

		mov es:[bx],byte ptr 2eh ; Wstawienie separatora kropki
		mov al, 00001111B  ; Kolor: jasny biały
		mov es:[bx+1],al
		mov es:[bx+3],al
		mov es:[bx+5],al

		; Wyświetlenie roku
		mov ax,cs:year  ; Pobranie wartości roku
		mov bx,82       ; Adresowanie pamięci ekranu dla roku

		div cl           ; Dzielenie roku przez 10
		add ah, 30H      ; Konwersja cyfry jedności na kod ASCII
		mov es:[bx+8], ah ; Zapisanie cyfry jedności w pamięci ekranu
		
		mov ah, 0        ; Zerowanie starszej części dzielnej
		div cl           ; Dzielenie przez 10
		add ah, 30H      ; Konwersja cyfry dziesiątek na kod ASCII
		mov es:[bx+6], ah ; Zapisanie cyfry dziesiątek w pamięci ekranu
		
		mov ah, 0        ; Zerowanie starszej części dzielnej
		div cl           ; Dzielenie przez 10
		add ah, 30H      ; Konwersja cyfry setek na kod ASCII
		mov es:[bx+4], ah ; Zapisanie cyfry setek w pamięci ekranu
		add al, 30H      ; Konwersja cyfry tysięcy na kod ASCII
		mov es:[bx+2], al ; Zapisanie cyfry tysięcy w pamięci ekranu

		mov es:[bx],byte ptr 2eh  ; Separator kropki
		mov al, 00001111B  ; Kolor: jasny biały
		mov es:[bx+1],al 
		mov es:[bx+3],al
		mov es:[bx+5],al
		mov es:[bx+7],al
		mov es:[bx+9],al

		pop dx  ; Odtworzenie poprzednich wartości rejestrów
		pop cx
		pop ax
		jmp dword PTR cs:wektor9
		
		wektor9 dd ?  ; Przechowywanie starego wektora przerwania
		day db ?      ; Przechowywanie wartości dnia
		year dw ?     ; Przechowywanie wartości roku
		month db ?    ; Przechowywanie wartości miesiąca
	wyswietl_AL ENDP

zacznij:
	mov al, 0
	mov ah, 5
	int 10  ; Przełącz tryb wideo
	
	mov ax, 0
	mov ds, ax 
	mov eax, ds:[36]  ; Pobranie starego wektora przerwania
	mov cs:wektor9, eax

	mov ax,0B800H  ; Adres segmentowy pamięci tekstowej ekranu
	mov es, ax

	mov ah,2AH  ; Pobranie aktualnej daty
	int 21H

	mov cs:day, dl
	mov cs:month, dh
	mov cs:year, cx

	mov ax, SEG wyswietl_AL
	mov bx, OFFSET wyswietl_AL
	cli  ; Wyłączenie przerwań
	mov ds:[36], bx
	mov ds:[38], ax
	sti  ; Włączenie przerwań

aktywne_oczekiwanie:
	cmp cs:day, 32
	jb aktywne_oczekiwanie

	mov eax, cs:wektor9 ; Zapisanie starego wektora przerwania
	cli ; Wyłączenie przerwań
	mov ds:[36], eax ; Przywrócenie starego wektora przerwania
	sti ; Włączenie przerwań

koniec:
	mov al, 0
	mov ah, 4CH
	int 21H  ; Zakończenie programu

rozkazy ENDS

nasz_stos SEGMENT stack
	db 128 dup (?)
nasz_stos ENDS

END zacznij
