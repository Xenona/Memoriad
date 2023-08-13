; todo
; 3. Find a way to print some cyrillic too (is this really necessary? thou, can be done with p.5)
; 4. Reduce all local fpu temp variables using only one in mem
; 5. Recompile glut32.dll with corrected chars display
; 6. Optimize memory usage: push vertices of all objs I use once, pass to opengl stackaddr, then ret N or add esp N
format  PE GUI 5.0
entry   WinMain

        include         ".\INCLUDE\win32ax.inc"         ; himxrmnski 

        include         ".\INCLUDE\api\kernel32.inc"    ;)
        include         ".\INCLUDE\api\user32.inc"
        include         ".\INCLUDE\api\gdi32.inc"       
        include         ".\INCLUDE\api\opengl.inc"
        include         ".\INCLUDE\DLL\glut.inc"        ; kdafllnlss

        include         ".\OBJECTS\Card.inc"
        include         ".\OBJECTS\SeaPlane.inc"
        include         ".\OBJECTS\SkyPlane.inc"
        include         ".\OBJECTS\SunPlane.inc"
        include         ".\OBJECTS\MainMenuButtons.inc"

        include         ".\CODE\Vector3.inc"
        include         ".\CODE\Matrix.inc"
        include         ".\CODE\Draw.inc"
        
        include         ".\DATA\CommonVariables.inc"
        include         ".\DATA\FpuConstants.inc"

        macro switch value
        {
                xor eax, eax
                mov eax, value
        }

        macro case value, label 
        {
                cmp eax, value 
                je  label
        }

data import

        library kernel32,       "KERNEL32.DLL",\
                user32,         "USER32.DLL",\
                gdi32,          "GDI32.DLL",\
                opengl32,       "OPENGL32.DLL",\
                glu32,          "GLU32.DLL",\
                glut32,         ".\INCLUDE\DLL\glut32.dll"

end data


proc WinMain

        locals
                hMainWindow     dd      ?
                msg             MSG
        endl

        xor     ebx, ebx

        invoke  RegisterClass, wndClass
        invoke  CreateWindowEx, ebx, className, className, WINDOW_STYLE,\
                        ebx, ebx, ebx, ebx, ebx, ebx, ebx, ebx
        mov     [hMainWindow], eax

        invoke  GetClientRect, eax, clientRect


        ; !!!!!!!!!!!!!!! return cursor to its normal state !!!!!!!!!!!!
        ; invoke  ShowCursor, ebx


        invoke  GetDC, [hMainWindow]
        mov     [hdc], eax

        invoke  ChoosePixelFormat, [hdc], pfd
        invoke  SetPixelFormat, [hdc], eax, pfd

        invoke  wglCreateContext, [hdc]
        invoke  wglMakeCurrent, [hdc], eax

        invoke  glViewport, 0, 0, [clientRect.right], [clientRect.bottom]

        invoke  glMatrixMode, GL_PROJECTION
        invoke  glLoadIdentity

        fild    [clientRect.right]      ; width
        fidiv   [clientRect.bottom]     ; width / height
        fstp    [aspect]                 
        invoke  gluPerspective, double FOV, double [aspect], double Z_NEAR, double Z_FAR

        invoke  glEnable, GL_DEPTH_TEST
        invoke  glShadeModel, GL_SMOOTH
        invoke  glHint, GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST

        lea     esi, [msg]

        .cycle:
                invoke  GetMessage, esi, ebx, ebx, ebx
                invoke  DispatchMessage, esi
        jmp     .cycle

endp

proc WindowProc uses ebx, hWnd, uMsg, wParam, lParam
 
 
        switch  dword[windowID] 
        case    0,      .window0                        ; Main menu
        case    1,      .window1


        .window0: 

                xor     ebx, ebx

                switch  [uMsg]
                case    WM_PAINT,       .onPaint0
                case    WM_DESTROY,     .onDestroy
                case    WM_KEYDOWN,     .onKeyDown0
                case    WM_MOUSEMOVE,   .onMouseMove0
                case    WM_LBUTTONDOWN, .onClick0

                invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam]

                jmp     .Return

                .onPaint0:
                stdcall Draw.Window0
                jmp     .ReturnZero
                
                .onKeyDown0:
                        switch [wParam]
                        case VK_ESCAPE, .onDestroy
                jmp     .ReturnZero

                .onClick0:
                        ; Object IDs on Window0:
                        ; 1 - Start Button 
                        ; 2 - Cards Button
                        ; 3 - Settings Button
                        ; 4 - Exit Button

                        cmp [objectNumSelected], 4
                        je .onDestroy

                        mov eax, dword[objectNumSelected]
                        mov dword[windowID], eax



                jmp     .ReturnZero

                .onMouseMove0: 

                        mov eax, [lParam]
                        movsx ebx, ax
                        mov dword[mouseX], ebx
                        sar eax, 16 
                        mov [mouseY], eax

                        stdcall On.Hover, 4, buttStartX1, buttStartBrdr

                jmp     .ReturnZero
        
        .window1: 
                xor     ebx, ebx

                switch  [uMsg]
                case    WM_PAINT,       .onPaint1
                case    WM_DESTROY,     .onDestroy
                case    WM_KEYDOWN,     .onKeyDown1
                case    WM_MOUSEMOVE,   .onMouseMove1
                case    WM_LBUTTONDOWN, .onLClick1


                invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam]

                jmp     .Return

                .onPaint1:
                        stdcall Draw.Window1
 
                jmp     .ReturnZero
                
                .onKeyDown1:
                        switch [wParam]
                        case VK_ESCAPE, .onDestroy
                        case VK_DOWN, .decCamAngle
                        case VK_UP, .incCamAngle
                jmp     .ReturnZero
                
                .onMouseMove1: 

                        mov eax, [lParam]
                        movsx ebx, ax
                        mov dword[mouseX], ebx
                        sar eax, 16 
                        mov [mouseY], eax

                        stdcall On.Hover, 32, card1X1, card1BrdrHandler

                jmp .ReturnZero

                .incCamAngle:

                        fld     [camAngle]
                        fadd    [camAngleStep]
                        fldpi
                        fmul    [twodd]
                        fcomp   
                        fstsw   ax 
                        shr     ax,  9 
                        jnc     @f
                        fldpi 
                        fmul    [twodd]
                        fsubp 
                        @@:
                        fstp    [camAngle]
                jmp .ReturnZero

                .decCamAngle:

                        fld     [camAngle]
                        fsub    [camAngleStep]
                        fldz 
                        fcomp 
                        fstsw   ax
                        shr     ax, 9
                        jc      @f
                        fcomp 
                        fldpi 
                        fmul    [twodd]
                        @@:
                        fstp    [camAngle]
                jmp .ReturnZero

                .onLClick1:
                fnop
                        cmp [objectNumSelected], -1
                        je .ReturnZero

                        mov esi, [objectNumSelected]
                        add esi, cardMatrix
                        mov eax, [esi]

                        cmp eax, 0
                        jne .ReturnZero

                        cmp [numOfOpened], 2
                        jae .ReturnZero

                        mov dword[esi], 2
                        inc [numOfOpened]


                jmp .ReturnZero
        
        .onDestroy:
        invoke  ExitProcess, 0

        .ReturnZero:
        xor     eax, eax

        .Return:        
        ret
endp

proc PutObject, verts:DWORD, colors:DWORD, vCount:DWORD
        ; verts - array of all verts grouped as triangles 
        ; colors - array of colors each for each vertex
        ; vCount - length of verts array


        invoke  glEnableClientState, GL_VERTEX_ARRAY
        invoke  glEnableClientState, GL_COLOR_ARRAY

        invoke  glVertexPointer, 3, GL_FLOAT, 0, [verts]
        invoke  glColorPointer, 3, GL_FLOAT, 0, [colors]
        invoke  glDrawArrays, GL_TRIANGLES, 0,  [vCount]


        invoke  glDisableClientState, GL_VERTEX_ARRAY
        invoke  glDisableClientState, GL_COLOR_ARRAY


        ret
endp;

proc Just.Wait uses eax ecx, toWait:DWORD 
        ; eax - to get curr time via GetTickCount
        ; ecx - to keep track on how much time has passed
        ; toWait - number of ticks to wait (10k in 1ms???)

        invoke GetTickCount
        mov ecx, eax                                    ; store init time value, time start

        @@:
                invoke GetTickCount                     
                sub eax, ecx                            ; how much has passed since time start
        cmp eax, [toWait]                               
        jb @b                                           ; if less than needed, wait a lil more

        ret 
endp

proc WorldToScreen uses ecx, worldX, worldY, worldZ             ; ! CHANGES EAX EDX EDI !
        locals 
                currX           dd ?
                currY           dd ?
                currZ           dd ?
        endl
        ; ecx - has to be pushed 'cause gl funcs change its contents
        ; worldX, Y, Z - coordinates of a particular vertex in world system of coords
        ; currX, Y, Z - temp vars for fpu

        ; eax edx edi - return parameters

        ; basic algorithm of transformation: 
        ; (1) - get projection matrix (Pm).
        ; (2) - get view matrix (Vm).
        ; (3) - get vector of a vertex (Vv).
        ;       ! Important: OpenGL assumes all matrix that are 
        ;       passed to its func are stored in transposed form,
        ;       but they're multiplied as ususal.
        ;       ! Notice: for the vector I used identity matrix 
        ;       with m41-m43 are filled with X, Y, Z.
        ; (4) - multiply Pm*Vm*Vv.
        ;       ! Notice: normally there'd be a vector as a result,
        ;       but as I used matrix instead of vector, matrix is 
        ;       the result.
        ; (5) - extract m41-m43 as X, Y, Z
        ; (6) - divide X, Y, Z by m44
        ; (7) - calculate screen coordinates using formulas below:
        ;       screenX = (X + 1.0) * screenWidth * 0.5;
        ;       screenY = (1.0 - Y) * screenHeight * 0.5;
        ;       screenZ = (Z + 1.0) * 0.5;
        ;       ! Notice: screenZ is usually used to find object that is 
        ;       closest to camera. Useful when vertices intersect: the 
        ;       smaller screenZ the closer the vertex.

        ; I do not multiply matrices manually. Instead, I use glMultMatrixf,
        ; so it's necessary to save initial state of set matrix stack;
        invoke glGetIntegerv, GL_MATRIX_MODE, currMode                            ; saving old mode
        invoke glGetError
        invoke glMatrixMode, GL_PROJECTION                                      ; setting new mode


        invoke glPushMatrix                                                     ; copying top matrix
        invoke glLoadIdentity                                                   ; replacing it with indentity

                                                                                ; (1)
        invoke gluPerspective, double FOV, double [aspect], double Z_NEAR, double Z_FAR 

        stdcall Matrix.LookAt, cameraPos, targetPos, upVector
                                                                                   ; (2) and Pm*Vm simultaneously
     
        stdcall Matrix.setDefault, matrixWtS                                    ; preparing Vm
        mov edi, [worldX]
        mov [matrixWtS.m41], edi
        mov edi, [worldY]
        mov [matrixWtS.m42], edi
        mov edi, [worldZ]
        mov [matrixWtS.m43], edi
        
        invoke glMultMatrixf, matrixWtS                                         ; (4)
        invoke glGetFloatv, GL_PROJECTION_MATRIX, matrixWtS                     ; saving to extract X, Y, Z

        fld [matrixWtS.m41]                                                     ; calculating screenX
        fdiv [matrixWtS.m44]
        fadd [onedd]
        fimul [clientRect.right]
        fdiv [twodd]
        fistp [currX]

        fld [matrixWtS.m42]                                                     ; calculating screenY
        fdiv [matrixWtS.m44]
        fchs 
        fadd [onedd]
        fimul [clientRect.bottom]
        fdiv [twodd]
        fistp [currY]

        fld [matrixWtS.m43]                                                     ; calculating screenZ
        fdiv [matrixWtS.m44]
        fadd [onedd]
        fdiv [twodd]
        fistp [currZ]

        invoke glPopMatrix                                                      ; restoring matrix stack
        invoke glMatrixMode, [currMode]                                         ; restoring old mode 
        invoke glGetError

        mov eax, [currX]                                                        ; returning values
        mov edx, [currY]
        mov edi, [currZ]

        ret 
endp 

proc On.Hover uses ecx ebx esi edi edx eax , numOfObjs, objArr, brdrHandler;
        ; ecx - for main loop (stores num of Objects)
        ; ebx - access to coords of a corner 
        ; esi - access to bool for border existing
        ; edi, eax, edx - WorldToScreen uses those to return x, y, z  
        ; numOfObjs - 4 if on a curr screen there are 4 buttons
        ; objArr - ptr to arr xyz1, xyz2, xyz1, xyz2... 
        ; brdrHandler - prt to arr 1stButtBrdr, 2ndButtBrdr... [0 or 1]

        ; x, y - mouse position
        ; ----------------------------------------> x increases
        ; |                  y less'n y2
        ; |
        ; |                              x2,
        ; |               ----------------- y2
        ; |  x less       |     object    |      x bigger
        ; |  than x1      |   projection  |      than x2
        ; |               |               |
        ; |            x1, ----------------
        ; |               y1
        ; |         
        ; |                 y bigger'n 1
        ; *
        ; y increases

        mov ebx, [objArr]       
        mov esi, [brdrHandler]

        xor ecx, ecx
        mov ecx, [numOfObjs]
        @@: 
                mov dword[esi], 0                                               ; clearing border before start

                stdcall WorldToScreen, dword[ebx], dword[ebx+4], 0.0            ; for X1, Y1
                cmp [mouseX], eax                                               ; the choice of all jumps is justified above
                jl .noBorder
                cmp [mouseY], edx
                jg .noBorder 
                                                                                ; for X2, Y2
                stdcall WorldToScreen, dword[ebx+8], dword[ebx+12], 1.0
                cmp [mouseX], eax
                jg .noBorder
                cmp [mouseY], edx
                jl .noBorder 


                mov dword[esi], 1                                               ; if got there -> mouse got on the obj

                push dword[numOfObjs]                                           ; saving selected object id (list of IDs in winProc)
                pop dword[objectNumSelected]                                    ; so when user clicks smth no need to check coords   
                sub [objectNumSelected], ecx                                    ; again
                inc [objectNumSelected]                                         ; indices of objects start from 1

                jmp .exit

                .noBorder:                                                       ; otherwise continue to the next obj

                mov [objectNumSelected], 0

                add esi, 4                                                      ; skip one brdrHandler
                add ebx, 16                                                     ; skip two corners (xy1, xy2)

        loop @b

        .exit: 

        ret 
endp

proc Object.move uses esi, vArr, vCount, x, y, z
        ; esi - to escape 'mem to mem' mov
        ; vArr - array of vertices to move
        ; vCount - number of those vertices
        ; x, y, z - the distance the obj will be moved

        stdcall Matrix.setDefault, trMatr               ; trMatr is defined in Matrix.inc

        mov esi, dword[x]
        mov [trMatr.m14], esi
        mov esi, dword[y]
        mov [trMatr.m24], esi 
        mov esi, dword[z] 
        mov [trMatr.m34], esi

        stdcall Matrix.MultOnXYZ1, trMatr, [vArr], [vCount]

        ret     
endp 
  