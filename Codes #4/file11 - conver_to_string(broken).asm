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

		; Pobranie argumentów (64-bitowe liczby)

		mov ebx, [ebp+8]  ; adres a
		mov eax, [ebx + 4] ; starsza czesc a
		mov ebx, [ebx] ; mlodsza czesc a
		mov ecx, [ebp+12] ; starsza czesc b
		mov edx, [ebp+16] ; mlodsza czesc b

		; Alokujemy pamiêæ na wynikowy string (2 liczby po 64 bity w binarnym UTF-16)
		; 64 bity to 64 znaki '0' lub '1', ka¿dy UTF-16 to 2 bajty + 1 bajt na null
		mov ecx, 260       ; 2 * 64 * 2 + 2 (wliczaj¹c \0)
		push ecx
		call _malloc       ; Alokujemy pamiêæ
		add esp, 4
		mov edi, eax       ; WskaŸnik na zaalokowany bufor (wynikowy string)

		; Przekszta³camy pierwsz¹ liczbê na binarny ci¹g znaków UTF-16
		mov esi, eax     ; WskaŸnik na pierwszy element tablicy (bufor wynikowy)
		push eax           ; Zachowujemy wskaŸnik na bufor

		mov ecx, 64        ; 64 bity
		mov eax, [ebp+8]   ; Pobierz wartoœæ liczby
	bin_loop1:
		shl eax, 1         ; Przesuwamy bit w lewo
		jc set_one1        ; Jeœli przeniesienie, to ustaw '1'
		mov word ptr [esi], '0'
		jmp next1
	set_one1:
		mov word ptr [esi], '1'
	next1:
		add esi, 2         ; Przesuwamy wskaŸnik (UTF-16 = 2 bajty)
		loop bin_loop1

		; Przekszta³camy drug¹ liczbê na binarny ci¹g znaków UTF-16
		mov ecx, 64        ; 64 bity
		mov eax, [ebp+12]  ; Pobierz wartoœæ liczby
	bin_loop2:
		shl eax, 1         ; Przesuwamy bit w lewo
		jc set_one2        ; Jeœli przeniesienie, to ustaw '1'
		mov word ptr [esi], '0'
		jmp next2
	set_one2:
		mov word ptr [esi], '1'
	next2:
		add esi, 2         ; Przesuwamy wskaŸnik (UTF-16 = 2 bajty)
		loop bin_loop2

		; Dodaj null-terminator (UTF-16 = 2 bajty nulli)
		mov word ptr [esi], 0

		pop eax            ; Przywracamy wskaŸnik na bufor do EAX (wartoœæ zwracana)

		pop edi
		pop esi
		pop ebp
		ret
	_convert_to_string ENDP
END
