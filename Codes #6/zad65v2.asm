; Program linie.asm
; Wyœwietlanie znaków * w takt przerwañ zegarowych
; Uruchomienie w trybie rzeczywistym procesora x86
; lub na maszynie wirtualnej
; zakoñczenie programu po naciœniêciu dowolnego klawisza
; asemblacja (MASM 4.0): masm gwiazdki.asm,,,;
; konsolidacja (LINK 3.60): link gwiazdki.obj;
.386
rozkazy SEGMENT use16
ASSUME cs:rozkazy
	linia PROC
		push ax
		push bx
		push es
		mov ax, 0A000H ; adres pamieci ekranu dla trybu 13H
		mov es, ax
		mov bx, cs:adres_piksela ; adres biezacy piksela
		mov al, cs:kolor
		mov es:[bx], al
		
		add bx, 321 ; przejscie do kolejnego miejsca
		cmp bx, 320*200
		jb dalej
		
		; kreslenie linii zostalo zakonczone - nastepna linia bedzie
		; kreslona w innym kolorze 1 wiersz wyzej
		sub cs:adres_nastepnej, word ptr 320
		mov bx, cs:adres_nastepnej
		inc cs:kolor
		dalej:
		mov cs:adres_piksela, bx
		pop es
		pop bx
		pop ax
		jmp dword ptr cs:wektor8
		kolor db 1

		; zaczynamy od lewego dolnego rogu
		adres_piksela dw 320*199
		wektor8 dd ?
		adres_nastepnej dw 320*199
	linia ENDP
		
	; INT 10H, funkcja nr 0 ustawia tryb sterownika graficznego
	zacznij:
		mov ah, 0
		mov al, 13H ; nr trybu
		int 10H
		mov bx, 0
		mov es, bx ; zerowanie rejestru ES
		mov eax, es:[32] ; odczytanie wektora nr 8
		mov cs:wektor8, eax; zapamiêtanie wektora nr 8
		; adres procedury 'linia' w postaci segment:offset
		mov ax, SEG linia
		mov bx, OFFSET linia
		cli ; zablokowanie przerwañ
		; zapisanie adresu procedury 'linia' do wektora nr 8
		mov es:[32], bx
		mov es:[32+2], ax
		sti ; odblokowanie przerwañ
		
	czekaj:
		mov ah, 1 ; sprawdzenie czy jest jakiœ znak
		int 16h ; w buforze klawiatury
		jz czekaj
		
		mov ah, 0 ; funkcja nr 0 ustawia tryb sterownika
		mov al, 3H ; nr trybu
		int 10H
		; odtworzenie oryginalnej zawartoœci wektora nr 8
		mov eax, cs:wektor8
		mov es:[32], eax
		; zakoñczenie wykonywania programu
		mov ax, 4C00H
		int 21H
		rozkazy ENDS
		
		stosik SEGMENT stack
			db 256 dup (?)
		stosik ENDS
		
	END zacznij
