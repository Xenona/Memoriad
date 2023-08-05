struct vector3
        x       dd         ?
        y       dd         ?
        z       dd         ?
ends

proc Vector3.Length uses esi, vector
        locals
                result  dd      ?
        endl

        mov     esi, [vector]
        fld     [esi + vector3.x]
        fmul    [esi + vector3.x]
        fld     [esi + vector3.y]
        fmul    [esi + vector3.y]
        fld     [esi + vector3.z]
        fmul    [esi + vector3.z]
        faddp
        faddp
        fsqrt
        fstp    [result]
        mov     eax, [result]
        ret
endp

proc Vector3.Normalize uses edi, vector
        locals
                l       dd      ?
        endl

        mov     edi, [vector]
        stdcall Vector3.Length, [vector]
        mov     [l], eax
        fld     [edi + vector3.x]
        fdiv    [l]
        fstp    [edi + vector3.x]
        fld     [edi + vector3.y]
        fdiv    [l]
        fstp    [edi + vector3.y]
        fld     [edi + vector3.z]
        fdiv    [l]
        fstp    [edi + vector3.z]
        ret
endp

proc Vector3.Cross uses esi edi ebx, v1, v2, result

        mov     esi, [v1]
        mov     edi, [v2]
        mov     ebx, [result]

        fld     [esi + vector3.y]
        fmul    [edi + vector3.z]
        fld     [esi + vector3.z]
        fmul    [edi + vector3.y]
        fsubp
        fstp    [ebx + vector3.x]

        fld     [esi + vector3.z]
        fmul    [edi + vector3.x]
        fld     [esi + vector3.x]
        fmul    [edi + vector3.z]
        fsubp
        fstp    [ebx + vector3.y]

        fld     [esi + vector3.x]
        fmul    [edi + vector3.y]
        fld     [esi + vector3.y]
        fmul    [edi + vector3.x]
        fsubp
        fstp    [ebx + vector3.z]

        ret
endp
