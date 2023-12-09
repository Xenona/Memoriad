proc File.LoadContent uses edi,\
     fileName

        locals
                hFile   dd      ?
                length  dd      ?
                read    dd      ?
                pBuffer dd      ?
        endl

        invoke  CreateFile, [fileName], GENERIC_READ, ebx, ebx, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, ebx
        mov     [hFile], eax

        invoke  GetFileSize, [hFile], ebx
        inc     eax
        mov     [length], eax
        stdcall malloc, [length]
        mov     [pBuffer], eax

        lea     edi, [read]
        invoke  ReadFile, [hFile], [pBuffer], [length], edi, ebx

        invoke  CloseHandle, [hFile]

        mov     eax, [pBuffer]

        ret
endp

proc File.LoadBmp uses edi,\
     fileName

        locals
                hFile   dd      ?
                length  dd      ?
                read    dd      ?
                pBuffer dd      ?
        endl

        invoke  CreateFile, [fileName], GENERIC_READ, ebx, ebx, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, ebx
 
        mov     [hFile], eax

        invoke  GetFileSize, [hFile], ebx

        inc     eax
        mov     [length], eax
        stdcall malloc, [length]
        mov     [pBuffer], eax


        lea     edi, [read]
        invoke  ReadFile, [hFile], [pBuffer], [length], edi, ebx

        invoke  CloseHandle, [hFile]

        mov     eax, [pBuffer]

        ret
endp


        currFile        WIN32_FIND_DATA ? 
        exePath         dd MAX_PATH dup (?) 

proc File.GetFilesInDirectory, dirPath
        
        locals
                filenamesArray  dd ? 
                hFind           dd ?  
                numberOfFiles   dd 0
                capacity        dd 16
                currentArrayPointer dd ?

                ; filenamesArray - holds initial value returned with malloc/realloc (aka the first byte)
                ; hFind - holds handler for FindNext/FindClose
                ; numberOfFiles - current number to calculate next pointer and size of array for realloc
                ; capacity - maximum number of files
                ; currentArrayPointer - holds current pointer for movs, not initial 
        endl

        ; (1) : Creating initial array for 16 paths 
        ;       each with the length of max path for 
        ;       windows (260 chars). Then saving it 
        ;       to locals. 

        ; (2) : Getting path of a C:/some/folders/to/file.exe
        ;       type
        
        ; (3) : Saving pointer to the path to esi 

        ; (4) : Making the pointer point to the last 
        ;       char of the path

        ; (5) : Making the pointer point to the last /
        ;       so I can get rid of file.exe later
        
        ; (6) : Saving /ASSETS/CARDS/ string pointer
         
        ; (7) : Saving /ASSETS/CARDS/ string pointer

        ; (8) : Getting the length of /ASSETS/CARDS/ to eax 

        ; (9) : esi was pointing to next char after last / 
        ;       edi was pointing to /ASSETS/CARDS  
        ;       so swapping them to perform further copy

        ; (10) : saving length of /ASSETS/CARDS for string 
        ;        instruction 

        ; (11) : copying 

        ; (12) : returning registers back as most String 
        ;        functions work with esi 

        ; (13) : Skipping folders 

        ; (14) : Checking current number of processed file 
        ;        names to fit into the array. If fits, just 
        ;        putting a filename to the next index, if 
        ;        not - going to enlarge the array 

        ; (15) : Capacity is multiplied by two. Just like in 
        ;        C++ vector :) 

        ; (16) : Multiplying current capacity by MAX_PATH and 
        ;        performing realloc for that. Ofc no error 
        ;        checking. Then saving the pointer to the local 

        ; (17) : Updating the current pointer to next index to 
        ;        write 

        ; (18) : Calculating how many chars takes the new exe path
        ;        then copying it to the array 
        
        ; (19) : Calculating what's left for filename and copying 
        ;        that too




        stdcall malloc, 16*260                                  ; (1)             
        mov [filenamesArray], eax
        mov [currentArrayPointer], eax
        
        invoke FindFirstFile, cardsPath, currFile       
        mov [hFind], eax 

        invoke GetModuleFileName, NULL, exePath, MAX_PATH       ; (2)
        mov esi, exePath                                        ; (3)
        stdcall String.NextString                               ; (4)
        stdcall String.FindLastAppearanceOf, 92 ; \ char          (5)
        mov edi, cardsFolderPath                                ; (6)
        push esi                                                
        push edi 
        mov esi, cardsFolderPath                                ; (7)
        stdcall String.Len                                      ; (8)
        pop edi     
        pop esi 
        xchg edi, esi                                           ; (9)
        mov ecx, eax                                            ; (10)
        rep movsb                                               ; (11)
        xchg edi, esi                                           ; (12)


        @@:

                mov eax, dword[currFile + WIN32_FIND_DATA.dwFileAttributes]
                and eax, FILE_ATTRIBUTE_DIRECTORY

                cmp eax, 0                                      ; (13)
                jnz .skip 

                        inc [numberOfFiles]                     ; (14)

                        mov eax, [capacity]
                        cmp eax, [numberOfFiles]
                        jg .justPut
                       
                        .ReallocAndPut:

                        mov eax, [capacity]                     ; (15)
                        shl eax, 1
                        mov [capacity], eax

                        mov eax, MAX_PATH                       ; (16)
                        mul [capacity]
                        stdcall realloc, [filenamesArray], eax
                        mov [filenamesArray], eax

                        mov eax, MAX_PATH                       ; (17)
                        mul [numberOfFiles]
                        sub eax, MAX_PATH
                        mov ebx, [filenamesArray]
                        add ebx, eax
                        mov [currentArrayPointer], ebx

                        .justPut:

                        mov edi, [currentArrayPointer] 

                        mov esi, exePath                        ; (18)
                        stdcall String.Len
                        mov ecx, eax
                        mov ebx, eax
                        rep movsb

                        mov ecx, MAX_PATH                       ; (19)
                        sub ecx, ebx

                        mov esi, currFile
                        add esi, WIN32_FIND_DATA.cFileName
                        rep movsb   

                        mov [currentArrayPointer], edi 


                .skip:


        invoke FindNextFile, [hFind], currFile
        cmp eax, 0
        jnz @b

        invoke FindClose, [hFind]
        mov eax, [filenamesArray]
        mov [filenamesArrayHandle], eax

        
        ret
endp