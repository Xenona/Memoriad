; todo
; 1. Check whether it'd be more effective to use gl's loadIdentity instead of my Matrix.SetDefault

format  PE GUI 5.0
entry   WinMain

        include         ".\INCLUDE\win32ax.inc"         ; himxrmnski 

        include         ".\INCLUDE\api\kernel32.inc"    ;)
        include         ".\INCLUDE\api\user32.inc"
        include         ".\INCLUDE\api\gdi32.inc"
        include         ".\INCLUDE\api\opengl.inc"
        include         ".\INCLUDE\DLL\glut.inc"

        include ".\OBJECTS\Card.inc"
        include ".\OBJECTS\SeaPlane.inc"
        include ".\OBJECTS\SkyPlane.inc"
        include ".\OBJECTS\SunPlane.inc"

        include ".\CODE\Matrix.inc"
        include ".\CODE\Draw.inc"

        COLOR_DEPTH     =       24
        PFD_FLAGS       =       PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER or PFD_DRAW_TO_WINDOW
        WINDOW_STYLE    =       WS_VISIBLE or WS_MAXIMIZE or WS_POPUP
        FOV             =       60.0
        Z_NEAR          =       0.001
        Z_FAR           =       10000.0

        wndClass        WNDCLASS                0, WindowProc, 0, 0, 0, 0, 0, 0, 0, className
        pfd             PIXELFORMATDESCRIPTOR   sizeof.PIXELFORMATDESCRIPTOR, 1, PFD_FLAGS, PFD_TYPE_RGBA, COLOR_DEPTH,\
                                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,\
                                                COLOR_DEPTH, 0, 0, PFD_MAIN_PLANE, 0, PFD_MAIN_PLANE

 

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

        className       db      "MEMORIAD (C) XENONA GAMES 2023", 0
        clientRect      RECT
        hdcBack         dd      ?
        hdc             dd      ?

        currMode        dd ?
        matrixWtS matrix

        windowID        db    0

        ; main menu 
        buttStartX1   dd      25.0    
        buttStartY1   dd      26.0
        buttStartZ1   dd      0.0

        buttStartX2   dd      85.0
        buttStartY2   dd      43.0
        buttStartZ2   dd     0.0

        buttViewX1    dd      25.0
        buttViewY1    dd      3.0
        buttViewZ1    dd      0.0

        buttViewX2    dd      85.0
        buttViewY2    dd      20.0
        buttViewZ2    dd      0.0
        
        buttSettsX1   dd      25.0
        buttSettsY1   dd      -20.0
        buttSettsZ1   dd      0.0

        buttSettsX2   dd      85.0
        buttSettsY2   dd      -3.0
        buttSettsZ2   dd      0.0

        buttExitX1    dd      25.0
        buttExitY1    dd      -43.0
        buttExitZ1    dd      0.0

        buttExitX2    dd      85.0
        buttExitY2    dd      -26.0
        buttExitZ2    dd      0.0

        buttStartBrdr dd      0
        buttViewBrdr  dd      0
        buttSettsBrdr dd      0  
        buttExitBrdr  dd      0


        

        
        include ".\DATA\CameraVariables.inc"
        params matrix
        aspect          dq      ?


        mouseX  dd ? 
        mouseY  dd ?

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


        invoke  glPushMatrix
        invoke  glMultMatrixf, params 
        invoke  glMultMatrixf, params
        invoke  glGetFloatv, GL_PROJECTION_MATRIX, params
        invoke  glPopMatrix
        


        fild    [clientRect.right]      ; width
        fidiv   [clientRect.bottom]     ; width / height
        fstp    [aspect]                ;
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
 

        

        switch  windowID 
        case    0,      .window0



        .window0: 

                xor     ebx, ebx

                switch  [uMsg]
                case    WM_PAINT,       .onPaint
                case    WM_DESTROY,     .onDestroy
                case    WM_KEYDOWN,     .onKeyDown
                case    WM_MOUSEMOVE,   .onMouseMove

                invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam]
                
                
                jmp     .Return

                .onPaint:
                stdcall Draw.Window0
                jmp     .ReturnZero
                
                .onKeyDown:
                cmp     [wParam], VK_ESCAPE
                je     .onDestroy


                .onMouseMove: 

                mov eax, [lParam]
                movsx ebx, ax
                mov dword[mouseX], ebx
                sar eax, 16 
                mov [mouseY], eax

                stdcall On.Hover, 4, buttStartX1, buttStartBrdr

                jmp     .ReturnZero
        
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
        invoke glGetFloatv, GL_MATRIX_MODE, currMode                            ; saving old mode
        invoke glMatrixMode, GL_PROJECTION                                      ; setting new mode


        invoke glPushMatrix                                                     ; copying top matrix
        invoke glLoadIdentity                                                   ; replacing it with indentity

                                                                                ; (1)
        invoke gluPerspective, double FOV, double [aspect], double Z_NEAR, double Z_FAR 

                                                                                ; (2) and Pm*Vm simultaneously
        invoke  gluLookAt, double [CamX],   double [CamY],   double [CamZ],\
                        double [WatchX], double [WatchY], double [WatchZ],\
                        double [UpvecX], double [UpvecY], double [UpvecZ]

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

                stdcall WorldToScreen, dword[ebx], dword[ebx+4], dword[ebx+8]   ; for X1, Y1
                cmp [mouseX], eax                                               ; the choice of all jumps is justified above
                jl noBorder
                cmp [mouseY], edx
                jg noBorder 
                                                                                ; for X2, Y2
                stdcall WorldToScreen, dword[ebx+12], dword[ebx+16], dword[ebx+20]
                cmp [mouseX], eax
                jg noBorder
                cmp [mouseY], edx
                jl noBorder 

                mov dword[esi], 1                                               ; if got there -> mouse got on the obj

                noBorder:                                                       ; otherwise continue to the next obj

                add esi, 4                                                      ; skip one brdrHandler
                add ebx, 24                                                     ; skip two corners (xyz1, xyz2)

        loop @b

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
