; Get place of the process's Heap
proc memInit

    invoke  GetProcessHeap
    mov     [hHeap], eax

    ret
endp

; Return begin of the memory allocated or null
; Return result in eax
proc malloc\
    sizeInBytes

    invoke HeapAlloc, [hHeap], 8, [sizeInBytes]

    ret
endp

; Release memory that was allocated
proc free\
    ptrMem

    invoke HeapFree, [hHeap], 8, [ptrMem]

    ret
endp

; Copy memory from src to dest
proc memcpy uses edi esi,\
    pDest, pSrc, countInByte

    mov     ecx, [countInByte]
    mov     edi, [pDest]    
    mov     esi, [pSrc]
    rep     movsb

    ret
endp

proc memzero uses edi,\
    pDest, countInByte

    mov     ecx, [countInByte]
    mov     edi, [pDest]
    mov     al, 0
    rep     stosb

    ret
endp

proc sizeOf ptr

    invoke  HeapSize, [hHeap], 8, [ptr]

    ret
endp

proc realloc ptr, countInBytes

    invoke  HeapReAlloc, [hHeap], 8, [ptr], [countInBytes]

    ret
endp