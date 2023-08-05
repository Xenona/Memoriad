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

proc Matrix.setDefault uses edi ecx eax, oldMatr

    mov edi, [oldMatr]
    mov ecx, 15
    xor     eax, eax
    rep     stosd 
    mov dword[edi], 1.0 
    mov dword[edi-20], 1.0
    mov dword[edi-40], 1.0
    mov dword[edi-60], 1.0

    ret 
endp

proc Matrix.LookAt uses esi edi ebx, camera, target, up

        locals
                temp    dd              ?
                matr    matrix
                zAxis   vector3
                xAxis   vector3
                yAxis   vector3
        endl

        lea     edi, [matr]
        mov     ecx, 4 * 4
        xor     eax, eax
        rep     stosd

        mov     esi, [camera]
        mov     edi, [target]
        mov     ebx, [up]

        fld     [edi + vector3.x]
        fsub    [esi + vector3.x]
        fstp    [zAxis.x]

        fld     [edi + vector3.y]
        fsub    [esi + vector3.y]
        fstp    [zAxis.y]

        fld     [edi + vector3.z]
        fsub    [esi + vector3.z]
        fstp    [zAxis.z]

        lea     eax, [zAxis]
        stdcall Vector3.Normalize, eax

        lea     eax, [zAxis]
        lea     ecx, [xAxis]
        stdcall Vector3.Cross, eax, ebx, ecx

        lea     eax, [xAxis]
        stdcall Vector3.Normalize, eax

        lea     eax, [xAxis]
        lea     ecx, [zAxis]
        lea     ebx, [yAxis]
        stdcall Vector3.Cross, eax, ecx, ebx

        lea     esi, [xAxis]
        lea     edi, [matr]
        fld     [esi + vector3.x]
        fstp    [edi + matrix.m11]
        fld     [esi + vector3.y]
        fstp    [edi + matrix.m21]
        fld     [esi + vector3.z]
        fstp    [edi + matrix.m31]

        fld     [ebx + vector3.x]
        fstp    [edi + matrix.m12]
        fld     [ebx + vector3.y]
        fstp    [edi + matrix.m22]
        fld     [ebx + vector3.z]
        fstp    [edi + matrix.m32]

        lea     esi, [zAxis]
        fld     [esi + vector3.x]
        fchs
        fstp    [edi + matrix.m13]
        fld     [esi + vector3.y]
        fchs
        fstp    [edi + matrix.m23]
        fld     [esi + vector3.z]
        fchs
        fstp    [edi + matrix.m33]

        fld1
        fstp    [edi + matrix.m44]

        invoke  glMultMatrixf, edi

        mov     esi, [camera]
        fld     [esi + vector3.z]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + vector3.y]
        fchs
        fstp    [temp]
        push    [temp]
        fld     [esi + vector3.x]
        fchs
        fstp    [temp]
        push    [temp]
        invoke  glTranslatef

        ret
endp