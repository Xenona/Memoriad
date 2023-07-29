proc Matrix.MultOnXYZ1 uses esi ebx ecx, M, vARR, vCOUNT 

    xor ebx, ebx
    xor ecx, ecx 

    mov ebx, [vARR]
    mov ecx, [vCOUNT]

    runThroughEachVert:

        push ecx 

        xor esi, esi 
        xor edi, edi 
        xor ecx, ecx 

        mov esi, [M]
        mov edi, ebx
        mov ecx, 3

        @@:
            fld dword[esi]
            fmul dword[ebx]
            fld dword[esi+4]
            fmul dword[ebx+4]
            fld dword[ebx+8]
            fmul dword[ebx+8]
            fld dword[esi+12]
            faddp
            faddp 
            faddp
            fstp dword[edi]

            add edi, 4
            add esi, 16

        loop @b

        pop ecx 
        add ebx, 12 

    loop runThroughEachVert

    ret 
endp