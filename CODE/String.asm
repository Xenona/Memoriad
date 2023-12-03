proc String.IntToStr uses edx ebx edi esi ecx, num, buf, startBufPos
    mov ebx, 10
    mov eax, [num]
    mov esi, [buf]
    add esi, [startBufPos]

    xor ecx, ecx
    .ConvertLoop:
        xor edx, edx
        div ebx
        add edx, '0'
        mov byte[esi], dl
        
        inc ecx
        inc esi

        cmp eax, 0
        
    jnz .ConvertLoop


    mov byte[esi], 0 ; zero terminated string 

    dec esi ; got last digit pos in string 
    mov edi, esi ; save last pos
    dec ecx
    sub esi, ecx ; got first digit pos in string
    .invertOrderLoop:
      cmp esi, edi 
      jge .stop

      mov al, byte[esi]
      mov ah, byte[edi]
      mov byte[esi], ah
      mov byte[edi], al

      inc esi 
      dec edi
      jmp .invertOrderLoop
      
    .stop:

  ret
endp
