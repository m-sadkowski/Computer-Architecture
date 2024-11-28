.686
.model flat

public _tablica_nieparzystych
extern _malloc : PROC

.data


.code
	_tablica_nieparzystych PROC
		push ebp
		mov ebp, esp 
		push edi
		push esi ; zapisujemy rejestry

		mov ebx, [ebp+8] ; wskaznik na pierwszy element tablicy znakow
		mov ecx, [ebp + 12] ; adres do rozmiaru tablicy znakow
		mov ecx, [ecx] ; rozmiar tablicy znakow

		mov esi, 0  ; licznik nieparzystych
	ile_nieparzystych:
		; pobieramy znak z tablicy
		mov edx, 0 
		mov dl, byte ptr [ebx] 

		bt edx, 0 ; sprawdzamy czy bit na pozycji 0 jest ustawiony (czy liczba jest nieparzysta)
		jnc nast
		inc esi ; jesli tak to zwiekszamy licznik nieparzystych
	nast:
		add ebx, 4 ; przesuwamy wskaznik na kolejny znak
		loop ile_nieparzystych ; powtarzamy dla wszystkich znakow

		lea eax, [esi * 4] ; mnozymy ilosc nieparzystych przez 4 (bo kazdy element tablicy to 4 bajty)

		push eax ; rozmiar tablicy 
		call _malloc ; alokujemy pamiec na tablice, w EAX adres nowej tablicy
		add esp, 4 ; usuwamy ze stosu rozmiar tablicy

		mov esi, 0 ; index w tablicy
		mov ecx, [ebp + 12] ; adres do rozmiaru tablicy znakow (liczba iteracji petli)
		mov ecx, [ecx] ; rozmiar tablicy znakow
		mov ebx, [ebp+8] ; wskaznik na pierwszy element tablicy znakow

		; NA TYM ETAPIE W EAX JEST ADRES NOWEJ TABLICY, W EBX ADRES TABLICY ZNAKOW KTORE PRZETWARZAMY, W ECX ROZMIAR TABLICY ZNAKOW, W ESI INDEX NOWEJ TABLICY
		; W PETLI BEDZIEMY PRZETWARZAC KOLEJNE ELEMENTY TABLICY ZNAKOW I DODAWAC JE DO NOWEJ TABLICY JESLI SA NIEPARZYSTE

	petla:
		; pobieramy znak z tablicy
		mov edx, 0 
		mov dl, byte ptr [ebx] 

		bt edx, 0 ; sprawdzamy czy bit na pozycji 0 jest ustawiony (czy liczba jest nieparzysta)
		jnc skip

		mov [eax + esi], edx ; dodajemy element do nowej tablicy
		add esi, 4 ; przesuwamy wskaznik na kolejny element
	skip:
		add ebx, 4 ; przesuwamy wskaznik na kolejny znak
		loop petla

		pop esi ; przywracamy rejestry
		pop edi
		pop ebp 
		ret
	_tablica_nieparzystych ENDP

END