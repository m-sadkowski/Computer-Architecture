.686
.model flat
public _kwadrat

.code
    _kwadrat PROC
        push ebp
        mov ebp, esp
        push ebx 

        mov eax, [ebp + 8]
        cmp eax, 0
        je koniec    
        cmp eax, 1
        je koniec 

        mov ebx, 0
        add ebx, eax
        add ebx, eax
        add ebx, eax
        add ebx, eax
        sub ebx, 4 ; ebx = 4 * a - 4

        sub eax, 2 ; eax = a - 2
        push eax ; przekazanie a-2 do rekurencyjnego wywo³ania
        call _kwadrat ; wywo³anie _kwadrat(a-2)
        add esp, 4 ; usuniêcie argumentu ze stosu

        add eax, ebx   

    koniec:
        pop ebx          
        pop ebp      
        ret
    _kwadrat ENDP
END
