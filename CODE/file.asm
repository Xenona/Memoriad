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
        
        ; DEBUGGGGGG
        push eax
        invoke GetLastError
        pop eax
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
        
        ;         std::vector<DWORD> GetFilesInDirectory(const TCHAR* directoryPath) {
        ;     std::vector<DWORD> files;

        ;     WIN32_FIND_DATA findFileData;
        ;     HANDLE hFind = FindFirstFile(directoryPath, &findFileData);


        ;     do {
        ;         if (!(findFileData.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY)) {

        ;             files.push_back( findFileData.cFileName);
        ;         }
        ;     } while (FindNextFile(hFind, &findFileData) != 0);

        ;     FindClose(hFind);
        ;     return files;
        ; }

        ; *char[260] filenames = malloc(for 32 * 260);
        ; 


        locals
                filenamesArray  dd ? 
                hFind           dd ?  
                numberOfFiles   dd 0
                capacity        dd 16
                currentArrayPointer dd ?
        endl


        stdcall malloc, 16*260
        mov [filenamesArray], eax
        mov [currentArrayPointer], eax
        
        invoke FindFirstFile, cardsPath, currFile
        mov [hFind], eax 

        invoke GetModuleFileName, NULL, exePath, MAX_PATH
        mov esi, exePath
        stdcall String.NextString
        stdcall String.FindLastAppearanceOf, 92 ; \ char
        mov edi, cardsFolderPath
        push esi 
        push edi 
        mov esi, cardsFolderPath
        stdcall String.Len
        pop edi
        pop esi 
        xchg edi, esi
        mov ecx, eax 
        rep movsb 
        xchg edi, esi
        mov byte[esi], 0


        @@:

                mov eax, dword[currFile + WIN32_FIND_DATA.dwFileAttributes]
                and eax, FILE_ATTRIBUTE_DIRECTORY

                cmp eax, 0
                jnz .skip 

                        inc [numberOfFiles]

        ;                 ;files.push_back( findFileData.cFileName);
                        mov eax, [capacity]
                        cmp eax, [numberOfFiles]
                        jg .justPut
                       
                        .ReallocAndPut:

                        mov eax, [capacity]
                        shl eax, 1
                        mov [capacity], eax
                        mov eax, MAX_PATH
                        mul [capacity]
                        stdcall realloc, [filenamesArray], eax
                        mov [filenamesArray], eax
                        mov eax, MAX_PATH
                        mul [numberOfFiles]
                        sub eax, MAX_PATH
                        mov ebx, [filenamesArray]
                        add ebx, eax
                        mov [currentArrayPointer], ebx

                        .justPut:

                        mov edi, [currentArrayPointer] 

                        mov esi, exePath
                        stdcall String.Len
                        mov ecx, eax
                        mov ebx, eax
                        rep movsb

                        mov ecx, MAX_PATH
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