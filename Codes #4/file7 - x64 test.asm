public szukaj64_max
public suma_siedmiu_liczb

.code
	szukaj64_max PROC
		push rbx; przechowanie rejestr�w
		push rsi 

		mov rbx, rcx; adres tablicy
		mov rcx, rdx; liczba element�w tablicy
		mov rsi, 0; indeks bie��cy w tablicy
		; w rejestrze RAX przechowywany b�dzie najwi�kszy dotychczas
		; znaleziony element tablicy - na razie przyjmujemy, �e jest
		; to pierwszy element tablicy
		mov rax, [rbx + rsi * 8]
		; zmniejszenie o 1 liczby obieg�w p�tli, bo ilo�� por�wna�
		; jest mniejsza o 1 od ilo�ci element�w tablicy
		dec rcx

	ptl: 
		inc rsi; inkrementacja indeksu
		; por�wnanie najwi�kszego, dotychczas znalezionego elementu
		; tablicy z elementem bie��cym
		cmp rax, [rbx + rsi * 8]
		jge dalej; skok, gdy element bie��cy jest
		; niewi�kszy od dotychczas znalezionego
		; przypadek, gdy element bie��cy jest wi�kszy
		; od dotychczas znalezionego
		mov rax, [rbx + rsi * 8]

	dalej: 
		loop ptl; organizacja p�tli
		; obliczona warto�� maksymalna pozostaje w rejestrze RAX
		; i b�dzie wykorzystana przez kod programu napisany w j�zyku C

		pop rsi
		pop rbx
		ret
	szukaj64_max ENDP

	suma_siedmiu_liczb PROC
		push rbp ; zapami�tanie rejestru rbp
		mov rbp, rsp ; rbp = rsp
		push rbx ; zapami�tanie rejestru rbx

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