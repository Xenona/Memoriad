proc shuffleArray uses esi edi edx ecx ebx, PArray, PArray2, length

    ; for (int i = length-1; i > 0; i--) {
    ;     int j = getRand(0, i);
    ;     int temp = array[j];
    ;     array[j] = array[i];
    ;     array[j] = temp;
    ; }

    

    mov esi, [length]
    dec esi
    shl esi, 2
    mov edi, [PArray]
    fnop
    fnop
    fnop
    fnop
    fnop
    @@:
    
        mov edx, esi 
        shr edx, 2
        stdcall getNumberInRange, 0, edx
        shl eax, 2
        mov ebx, eax
        mov eax, dword[edi + ebx]
        xchg eax, dword[edi + esi]
        mov dword[edi + ebx], eax        
        
    ; mov edx, [edi]

    sub esi, 4
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