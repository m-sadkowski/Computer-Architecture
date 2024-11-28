public szukaj64_max
public suma_siedmiu_liczb

.code
	szukaj64_max PROC
		push rbx; przechowanie rejestrów
		push rsi 

		mov rbx, rcx; adres tablicy
		mov rcx, rdx; liczba elementów tablicy
		mov rsi, 0; indeks bie¿¹cy w tablicy
		; w rejestrze RAX przechowywany bêdzie najwiêkszy dotychczas
		; znaleziony element tablicy - na razie przyjmujemy, ¿e jest
		; to pierwszy element tablicy
		mov rax, [rbx + rsi * 8]
		; zmniejszenie o 1 liczby obiegów pêtli, bo iloœæ porównañ
		; jest mniejsza o 1 od iloœci elementów tablicy
		dec rcx

	ptl: 
		inc rsi; inkrementacja indeksu
		; porównanie najwiêkszego, dotychczas znalezionego elementu
		; tablicy z elementem bie¿¹cym
		cmp rax, [rbx + rsi * 8]
		jge dalej; skok, gdy element bie¿¹cy jest
		; niewiêkszy od dotychczas znalezionego
		; przypadek, gdy element bie¿¹cy jest wiêkszy
		; od dotychczas znalezionego
		mov rax, [rbx + rsi * 8]

	dalej: 
		loop ptl; organizacja pêtli
		; obliczona wartoœæ maksymalna pozostaje w rejestrze RAX
		; i bêdzie wykorzystana przez kod programu napisany w jêzyku C

		pop rsi
		pop rbx
		ret
	szukaj64_max ENDP

	suma_siedmiu_liczb PROC
		push rbp ; zapamiêtanie rejestru rbp
		mov rbp, rsp ; rbp = rsp
		push rbx ; zapamiêtanie rejestru rbx

		mov rax, 0
		add rax, rcx
		add rax, rdx
		add rax, r8
		add rax, r9
		; 8 bajtow - dopelnienie do wielokrotnosci 16
		; 24 bajty - trzy parametry przekazywane
		; 32 bajty - shadow space
		mov rbx, [rbp+48]
		add rax, rbx
		mov rbx, [rbp+56]
		add rax, rbx
		mov rbx, [rbp+64]
		add rax, rbx

		pop rbx ; przywrocenie rejestru rbx
		pop rbp ; przywrocenie rejestru rbp
		ret
	suma_siedmiu_liczb ENDP
END