struct matrix
    m11     dd      ? 
    m12     dd      ? 
    m13     dd      ? 
    m14     dd      ? 

    m21     dd      ? 
    m22     dd      ? 
    m23     dd      ? 
    m24     dd      ? 

    m31     dd      ? 
    m32     dd      ? 
    m33     dd      ? 
    m34     dd      ? 

    m41     dd      ? 
    m42     dd      ? 
    m43     dd      ? 
    m44     dd      ? 
ends

trMatr matrix                         ; matrix for all transformations



proc Matrix.MultOnXYZ1 uses esi ebx ecx, M, vARR, vCOUNT 
    ; esi - pointer to matrix elems
    ; ebx - pointer to xyz (1 is omitted in calcs) in the array of vertices
    ; ecx - loop counter (stores num of verts in outer and 3 in inner)
    ; M - addr of matrix being multiplicated 
    ; vARR - array of vertices of the object being transformed
    ; vCOUNT - length of array of vertices

    xor ebx, ebx
    xor ecx, ecx 

    mov ebx, [vARR]
    mov ecx, [vCOUNT]

    runThroughEachVert:

        push ecx                                        ; to use only ecx in loops

        xor esi, esi                                    ; getting rid of prev values
        xor edi, edi 
        xor ecx, ecx 

        mov esi, [M]                                    ; return to begin of matrix
        mov edi, ebx                                    ; addr to write changed value of a coord
        mov ecx, 3                                      ; for x, y, and z

        multCurrVertCoords:                             ; mult one row of matr with whole vect
            fld dword[esi]                               
            fmul dword[ebx]                             ; m#1*x
            fld dword[esi+4]                            
            fmul dword[ebx+4]                           ; m#2*y    
            fld dword[esi+8]                
            fmul dword[ebx+8]                           ; m#3*z
            fld dword[esi+12]                           ; load m#4=1 'cause vector's w=1 anyway                                 
            faddp                                       
            faddp 
            faddp
            fstp dword[edi]                             ; write to coord its changed value

            add edi, 4                                  ; switch to next coord 
            add esi, 16                                 ; and matrix row

        loop multCurrVertCoords

        pop ecx                                         ; return main counter 
        add ebx, 12                                     ; skip three processed coords

    loop runThroughEachVert

    ret 
endp

proc Matrix.setDefault 

    mov [trMatr.m11], 1.0
    mov [trMatr.m12], 0.0
    mov [trMatr.m13], 0.0
    mov [trMatr.m14], 0.0

    mov [trMatr.m21], 0.0
    mov [trMatr.m22], 1.0
    mov [trMatr.m23], 0.0
    mov [trMatr.m24], 0.0

    mov [trMatr.m31], 0.0
    mov [trMatr.m32], 0.0
    mov [trMatr.m33], 1.0
    mov [trMatr.m34], 0.0

    mov [trMatr.m41], 0.0
    mov [trMatr.m42], 0.0
    mov [trMatr.m43], 0.0
    mov [trMatr.m44], 1.0


    ret 
endp