proc shuffleArray uses esi edi edx ecx ebx, PArray, length

    ; for (int i = length-1; i > 0; i--) {
    ;     int j = getRand(0, i);
    ;     int temp = array[j];
    ;     array[j] = array[i];
    ;     array[j] = temp;
    ; }


    mov esi, [length]
    dec esi
    mov edi, [PArray]
    @@:
    
        stdcall getNumberInRange, 0, esi
        mov ebx, eax
        movzx eax, byte[edi + ebx]
        xchg al, byte[edi + esi]
        mov byte[edi + ebx], al        
        
    mov edx, [edi]

    dec esi
    jg @b

    ret
endp

proc getNumberInRange uses ecx edx, min, max 

    rdrand eax 
    mov ecx, [max]
    sub ecx, [min]
    inc ecx 
    xor edx, edx 
    div ecx 
    add edx, [min]
    xchg eax, edx 
    
    ret 
endp