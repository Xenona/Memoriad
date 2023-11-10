proc Texture.Constructor uses edi esi,\
    pID, pFileImage, texType, texSlot, format, pixelType

    mov     eax, [texType]
    mov     dword [esi], eax

    mov     esi, [pID]

    ; Block textures
    invoke  glGenTextures, 1, esi 
    invoke  glActiveTexture, [texSlot]
    invoke  glBindTexture, [texType], dword [esi]

    ; Box texture settings
    invoke  glTexParameteri, [texType], GL_TEXTURE_WRAP_S, GL_REPEAT
    invoke  glTexParameteri, [texType], GL_TEXTURE_WRAP_T, GL_REPEAT
    invoke  glTexParameteri, [texType], GL_TEXTURE_MIN_FILTER, GL_NEAREST
    invoke  glTexParameteri, [texType], GL_TEXTURE_MAG_FILTER, GL_NEAREST

    stdcall File.LoadBmp, [pFileImage]
    mov     edi, eax 
    add     edi, dword [eax + 10]
    invoke  glTexImage2D, [texType], ebx,\ 
                    GL_RGB8, dword [eax + 18], dword [eax + 22], ebx,\ 
                    [format], [pixelType], edi
    invoke  HeapFree, [hHeap], ebx, eax
    invoke  glGenerateMipmap, [texType]
    
    invoke  glBindTexture, [texType], 0

    ret
endp

proc Texture.texUnit uses esi edi,\
    shaderID, pStrUniform, unit   

    locals 
        texUni      GLuint      ? 
    endl

    invoke  glGetUniformLocation, [shaderID], [pStrUniform]
    mov     [texUni], eax

    stdcall Shader.Activate, [shaderID]
    invoke  glUniform1i, [texUni], [unit]

    ret
endp

proc Texture.Bind uses esi,\
    TexType, TexID, texSlot

    invoke glActiveTexture, [texSlot]
    invoke glBindTexture, [TexType], [TexID]

    ret
endp

proc Texture.Unbind uses esi,\
    TexType, TexID

    invoke  glBindTexture, [TexType], 0

    ret
endp

proc Texture.Delete uses esi,\
    pTexID

    invoke  glDeleteTextures, 1, [pTexID]

    ret
endp