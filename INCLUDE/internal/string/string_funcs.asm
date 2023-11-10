proc strlen uses edi,\
    pSrc

    mov     al, 0
    mov     edi, [pSrc]
    push    edi
    repne   scasb

    pop     eax
    sub     edi

    ret
endp

; Create new string in Heap and copy cntInBytes bytes in from pSrc
proc strcpy uses edi esi,\
    pSrc, cntInBytes
    
    stdcall strlen, [pSrc]
    cmp     eax, [cntInBytes]
    jae     .Skip

    mov     [cntInBytes], eax

.Skip:

    mov     ecx, [cntInBytes]

    inc     [cntInBytes]
    stdcall malloc, [cntInBytes]
    mov     edi, eax

    mov     esi, [pSrc]
    rep     movsb
    mov     byte [edi], 0

    ret
endp

proc strconcat uses edi esi,\
    pDest, pSrc

    locals 
        sizeStr     dd      0
        sizeDest    dd      0
        sizeSrc     dd      0
    endl

    stdcall strlen, [pDest]
    mov     [sizeDest], eax

    stdcall strlen, [pSrc]
    mov     [sizeSrc], eax
    
    add     eax, [sizeDest]
    inc     eax

    stdcall realloc, [pDest], eax

    cmp     eax, NULL 
    je      .Ret


.Ret:

    ret
endp