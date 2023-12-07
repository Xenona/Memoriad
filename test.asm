format PE GUI 4.0
entry start

include         ".\INCLUDE\win32ax.inc"         

start:
    push DST_PATH
    call EnumFiles

    DST_PATH db 'C:\Users\golub\Desktop\Memoriad\ASSETS\CARDS\*.bmp', 0        ; Directory to list files from. Change it according to your needs.

    proc EnumFiles, szPath
    locals
    hFindFile dd ?
    endl
    sub esp, 0x140                      ; Free some space on the stack for our WIN32_FIND_DATA struct
    mov ebx, esp                        ; ebx now holds our struct
    push ebx
    push [szPath]
    call [FindFirstFileA]
    push eax
    invoke GetLastError 
    pop eax
    test eax, eax
    jz .list_end
      mov [hFindFile], eax
      lea esi, [ebx+0x2C]               ; = FileName
      mov ecx, [ebx+0x20]               ; = FileSize
.fileloop:
    push ebx
    push [hFindFile]
    call [FindNextFileA]
    test eax, eax
    jz .list_end                        ; If there're no more files, exit the loop
      mov ecx, [ebx+0x20]               ; = FileSize (in Bytes). Is 0 when it's a directory
      invoke  MessageBoxA,HWND_DESKTOP,esi,txt_msg_caption,0  ; =>> Show a MessageBox containing the name of the current file/directory <==
      jmp .fileloop
.list_end:
    add esp, 0x140                      ; Restore stack
    invoke  MessageBoxA,HWND_DESKTOP,txt_msg_text,txt_msg_caption,0
    call [ExitProcess]

; Custom Data: Some Strings which will be shown in a MessageBoxA later:
section '.data' data readable writeable
          txt_msg_caption db 'TEST',0
          txt_msg_text    db '[ Listing the directory has been finished ]',0

; Imported functions and corresponding names of DLL files:
section '.idata' import data readable writeable
  library kernel,'KERNEL32.DLL',\
          user,'USER32.DLL'

  import kernel,\
         ExitProcess,'ExitProcess',\
         FindFirstFileA,'FindFirstFileA',\
         FindNextFileA,'FindNextFileA',\
         GetLastError, 'GetLastError'

  import user,\
         MessageBoxA,'MessageBoxA'

ret     ; Not really needed
endp