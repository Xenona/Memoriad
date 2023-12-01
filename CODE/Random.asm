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
    @@:
    
        mov edx, esi 
        shr edx, 2
        stdcall getNumberInRange, 0, edx
        shl eax, 2
        mov ebx, eax
        mov eax, dword[edi + ebx]
        xchg eax, dword[edi + esi]
        mov dword[edi + ebx], eax        

        push ebp
        mov ebp, [PArray2]
        mov eax, dword[ebp + ebx]
        xchg eax, dword[ebp + esi]
        mov dword[ebp + ebx], eax

        pop ebp


    ; Gotta check why on earth did I use this one 
    ; line and why did that worked
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