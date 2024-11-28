.686
.model flat

public _convert_to_array
extern _malloc : PROC

.data

cztery dd 4
dziesiec dd 10

.code
	_convert_to_array PROC
		push ebp
		mov ebp, esp 
		push edi
		push esi ; zapisujemy rejestry

		mov ebx, [ebp+8] ; wskaznik na pierwszy element tablicy znakow

		mov eax, 1020 ; 255*4
		push eax ; rozmiar tablicy 
		call _malloc ; alokujemy pamiec na tablice
		add esp, 4 ; usuwamy ze stosu rozmiar tablicy

		mov esi, eax ; zapisujemy adres tablicy w esi (wskaznik na pierwszy element)
		mov edi, eax ; zapisujemy adres tablicy w edi (wskaznik na pierwszy element)

		mov ecx, 255 ; max ilosc znakow w tablicy
		mov eax, 0 ; mul dziala na eax 

	petla:
		mov edx, 0 ; zerujemy edx
		mov dl, byte ptr [ebx] ; pobieramy znak z tablicy

		cmp dl, 0 ; jesli 0 to koniec 
		je koniec 

		cmp dl, 20h ; czy spacja?
		je dodaj

		sub dl, 30h ; wartosc ze znaku ascii
		push ecx ; zapisujemy ecx na stosie
		movzx ecx, dl ; zapisujemy wartosc ze znaku w ecx 
		mul dziesiec ; mnozymy eax przez 10
		add eax, ecx ; dodajemy cyfre do wyniku
		pop ecx ; przywracamy ecx ze stosu
		jmp nast

	dodaj: 
		mov [esi], eax ; dodajemy element do nowej tablicy
		add esi, 4 ; przesuwamy wskaznik na kolejny element
		mov eax, 0 ; zerujemy eax

	nast:
		inc ebx ; przesuwamy wskaznik na kolejny znak
		loop petla ; powtarzamy dla wszystkich znakow


	koniec:
		mov [esi],eax ; dodajemy ostatni element
		add esi, 4 ; przesuwamy wskaznik na kolejny element
		mov eax, 0 ; zerujemy eax

		mov eax,edi ; odzyskujemy adres tablicy

		pop esi ; przywracamy rejestry
		pop edi
		pop ebp 
		ret
	_convert_to_array ENDP

END