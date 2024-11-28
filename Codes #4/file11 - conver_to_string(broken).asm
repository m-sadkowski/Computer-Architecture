.686
.model flat
public _convert_to_string
extern _malloc : PROC

.code
	_convert_to_string PROC
		push ebp
		mov ebp, esp
		push esi
		push edi

		; Pobranie argument�w (64-bitowe liczby)

		mov ebx, [ebp+8]  ; adres a
		mov eax, [ebx + 4] ; starsza czesc a
		mov ebx, [ebx] ; mlodsza czesc a
		mov ecx, [ebp+12] ; starsza czesc b
		mov edx, [ebp+16] ; mlodsza czesc b

		; Alokujemy pami�� na wynikowy string (2 liczby po 64 bity w binarnym UTF-16)
		; 64 bity to 64 znaki '0' lub '1', ka�dy UTF-16 to 2 bajty + 1 bajt na null
		mov ecx, 260       ; 2 * 64 * 2 + 2 (wliczaj�c \0)
		push ecx
		call _malloc       ; Alokujemy pami��
		add esp, 4
		mov edi, eax       ; Wska�nik na zaalokowany bufor (wynikowy string)

		; Przekszta�camy pierwsz� liczb� na binarny ci�g znak�w UTF-16
		mov esi, eax     ; Wska�nik na pierwszy element tablicy (bufor wynikowy)
		push eax           ; Zachowujemy wska�nik na bufor

		mov ecx, 64        ; 64 bity
		mov eax, [ebp+8]   ; Pobierz warto�� liczby
	bin_loop1:
		shl eax, 1         ; Przesuwamy bit w lewo
		jc set_one1        ; Je�li przeniesienie, to ustaw '1'
		mov word ptr [esi], '0'
		jmp next1
	set_one1:
		mov word ptr [esi], '1'
	next1:
		add esi, 2         ; Przesuwamy wska�nik (UTF-16 = 2 bajty)
		loop bin_loop1

		; Przekszta�camy drug� liczb� na binarny ci�g znak�w UTF-16
		mov ecx, 64        ; 64 bity
		mov eax, [ebp+12]  ; Pobierz warto�� liczby
	bin_loop2:
		shl eax, 1         ; Przesuwamy bit w lewo
		jc set_one2        ; Je�li przeniesienie, to ustaw '1'
		mov word ptr [esi], '0'
		jmp next2
	set_one2:
		mov word ptr [esi], '1'
	next2:
		add esi, 2         ; Przesuwamy wska�nik (UTF-16 = 2 bajty)
		loop bin_loop2

		; Dodaj null-terminator (UTF-16 = 2 bajty nulli)
		mov word ptr [esi], 0

		pop eax            ; Przywracamy wska�nik na bufor do EAX (warto�� zwracana)

		pop edi
		pop esi
		pop ebp
		ret
	_convert_to_string ENDP
END
