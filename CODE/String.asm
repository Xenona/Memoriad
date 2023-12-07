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

proc String.NextString

  ; this function accepts pointer 
  ; via esi register and moves the 
  ; pointer till the next string 
  ; starts: 

  ; before the call: 
  ; S T R I N G 0 N E X T S T R I N G 0 
  ; * 

  ; after the call:
  ; S T R I N G 0 N E X T S T R I N G 0
  ;               * 

  ; be sure you have 0s at the ends of 
  ; all strings (and strings are 1 byte???) 

  @@: 
  inc esi
  cmp byte[esi], 0
  jne @b
  inc esi


  ret 
endp

proc String.Len

  ; supposes that string pointer
  ; lies in esi

  ; returnes the length in eax

  push esi 
  xor eax, eax
  @@: 
  cmp byte[esi], 0
  je .counted
  inc esi
  inc eax
  jnz @b

  pop esi  

  .counted
  ret 
endp
