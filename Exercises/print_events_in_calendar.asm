.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC

public _main

.data
    kalendarz dd 00000000h, 00000000h, 00000000h, 00000000h, 00000000h, 00000000h, 
    11110000000000000010000000000110b, 00000000h, 00000000h, 00000000h, 00000000h, 00000000h
    ;lipiec    ;sierpien  ;wrzesien  ;pazdziernik;listopad ;grudzien
    znaki db 12 dup (?) 
    tytul db "Swieta", 0

.code

wyswietl_EAX PROC
		pusha ; zapisanie rejestr�w og�lnych

		mov esi, 10 ; indeks w tablicy 'znaki'
		mov ebx, 10 ; dzielnik r�wny 10

	konwersja:
		mov edx, 0 ; zerowanie starszej cz�ci dzielnej
		div ebx ; dzielenie przez 10, reszta w EDX, iloraz w EAX
		add dl, 30H ; zamiana reszty z dzielenia na kod ASCII
		mov znaki [esi], dl; zapisanie cyfry w kodzie ASCII
		dec esi ; zmniejszenie indeksu
		cmp eax, 0 ; sprawdzenie czy iloraz = 0
		jne konwersja ; skok, gdy iloraz niezerowy
		
		 ; wype�nienie pozosta�ych bajt�w spacjami i wpisanie znak�w nowego wiersza
	wypeln:
		or esi, esi
		jz wyswietl ; skok, gdy ESI = 0
		mov byte PTR znaki [esi], 20H ; kod spacji
		dec esi ; zmniejszenie indeksu
		jmp wypeln

	wyswietl:
		mov byte PTR znaki [0], 0AH ; kod nowego wiersza
		mov byte PTR znaki [11], 0AH ; kod nowego wiersza
		; wy�wietlenie cyfr na ekranie
		push dword PTR 12 ; liczba wy�wietlanych znak�w
		push dword PTR OFFSET znaki ; adres wy�w. obszaru
		push dword PTR 1; numer urz�dzenia (ekran ma numer 1)
		call __write ; wy�wietlenie liczby na ekranie
		add esp, 12 ; usuni�cie parametr�w ze stosu

		popa ; przywr�cenie rejestr�w og�lnych
		ret ; powr�t do miejsca wywo�ania
wyswietl_EAX ENDP

swieta PROC
    pusha

    dec ecx ; index miesiaca jest o 1 nizszy niz jego numer
    lea ebx, [ebx + ecx * 4] ; adres miesiaca jest w ebx
    mov edx, [ebx] ; pobranie danych, teraz w eax jest lipiec (10001001h)
    mov ebx, 0

    petla:
        inc ebx ; zwiekszenie dnia
        shl edx, 1 ; przesuniecie o bit w lewo (spada na flage carry)
        jnc petla ; jesli nie ma swieta w tym dniu to skok

        mov eax, ebx ; przypisanie dnia do eax
        call wyswietl_EAX ; wywolanie procedury wyswietlajacej eax (dzien)

        cmp edx, 0 ; sprawdzenie czy sa jeszcze jakies swieta w miesiacu (lub czy juz przesunieto tak ze zostaly same 0)
        je koniec
        jmp petla

    koniec:

    popa
    ret
swieta ENDP


_main PROC
    mov cl, 7 ; lipiec
    mov ebx, OFFSET kalendarz ; adres kalendarza

    call swieta

    push 0
    call _ExitProcess@4
_main ENDP
END
