.386
rozkazy SEGMENT use16
ASSUME CS:rozkazy

;============================================================
; procedura obsługi przerwania zegarowego
obsluga_zegara PROC
    ; przechowanie używanych rejestrów
    push ax
    push bx
    push dx
    push si
    push es
    push ds

    mov si, 0

petla:
    ; wpisanie adresu pamięci ekranu do rejestru ES
    mov ax, 0B800h     ; adres pamięci ekranu
    mov es, ax

    ; zmienna 'licznik' zawiera adres bieżący w pamięci ekranu
    mov bx, cs:licznik

    mov ax, 0040h      
    mov ds, ax         
    mov al, ds:[si+1Eh]    ; odczytanie wartości z pamięci pod adresem [0040:001Eh]

    mov ah, al         ; skopiowanie bajtu do AH
    shr ah, 4          ; starsza cyfra w AH
    and al, 0Fh        ; młodsza cyfra w AL

    ; konwersja starszej cyfry na ascii
    cmp ah, 9
    jbe cyfra
    add ah, 7 ; litera       
cyfra:
    add ah, 30h  
    
     ; konwersja starszej cyfry na ascii
    cmp al, 9
    jbe cyfra2
    add al, 7         
cyfra2:
    add al, 30h     

    ; starsza cyfra
    mov byte PTR es:[bx], ah 
    mov byte PTR es:[bx+1], 00000111B

    ; młodsza cyfra
    mov byte PTR es:[bx+2], al
    mov byte PTR es:[bx+3], 00000111B

    add si, 1

    cmp si, 16
    jb petla

    add bx, 8
    cmp bx, 256
    jb wysw_dalej

    mov bx, 0

wysw_dalej:
    mov cs:licznik, bx

    ; odtworzenie rejestrów
    pop ds
    pop es
    pop si
    pop dx
    pop bx
    pop ax

    ; skok do oryginalnej procedury obsługi przerwania zegarowego
    jmp dword PTR cs:wektor8


; Zmienne
licznik dw 640         ; Początkowy adres na ekranie (2. wiersz)
adres_pamieci dw 001Eh ; Początkowy adres w pamięci BIOS
wektor8 dd ?

obsluga_zegara ENDP
;============================================================

zacznij:
    mov al, 0
    mov ah, 5
    int 10
    mov ax, 0
    mov ds, ax

    ; Odczytanie oryginalnej procedury obsługi przerwania zegarowego
    mov eax, ds:[32]
    mov cs:wektor8, eax

    ; Wpisanie do wektora nr 8 adresu procedury 'obsluga_zegara'
    mov ax, SEG obsluga_zegara
    mov bx, OFFSET obsluga_zegara
    cli
    mov ds:[32], bx
    mov ds:[34], ax
    sti

    ; Oczekiwanie na naciśnięcie klawisza 'x'
aktywne_oczekiwanie:
    mov ah, 1
    int 16H
    jz aktywne_oczekiwanie
    mov ah, 0
    int 16H
    cmp al, 'x'
    jne aktywne_oczekiwanie

    ; Deinstalacja procedury przerwań i zakończenie programu
    mov eax, cs:wektor8
    cli
    mov ds:[32], eax
    sti

    mov al, 0
    mov ah, 4CH
    int 21H

rozkazy ENDS

nasz_stos SEGMENT stack
    db 128 dup (?)
nasz_stos ENDS

END zacznij
