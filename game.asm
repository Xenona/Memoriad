format  PE GUI 5.0
entry   WinMain

        include         ".\INCLUDE\win32ax.inc"

        include         ".\INCLUDE\api\kernel32.inc"
        include         ".\INCLUDE\api\user32.inc"
        include         ".\INCLUDE\api\gdi32.inc"
        include         ".\INCLUDE\api\opengl.inc"

        include ".\OBJECTS\Card.inc"
        include ".\OBJECTS\SeaPlane.inc"
        include ".\OBJECTS\SkyPlane.inc"
        include ".\OBJECTS\SunPlane.inc"

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

macro JumpIf value, label
{
        cmp     eax, value
        je      label
}



data import

        library kernel32,       "KERNEL32.DLL",\
                user32,         "USER32.DLL",\
                gdi32,          "GDI32.DLL",\
                opengl32,       "OPENGL32.DLL",\
                glu32,          "GLU32.DLL"

end data

        className       db      "MEMORY GAME (C) XENONA GAMES 2023", 0
        clientRect      RECT
        hdcBack         dd      ?
        time            dd      ?
        hdc             dd      ?
        angle           dd      110.0
        step            dd      3.14

        include "CameraVariables.inc"
        include "Matrix.inc"

proc WinMain

        locals
                hMainWindow     dd      ?
                msg             MSG
                aspect          dq      ?
        endl

        xor     ebx, ebx

        invoke  RegisterClass, wndClass
        invoke  CreateWindowEx, ebx, className, className, WINDOW_STYLE,\
                        ebx, ebx, ebx, ebx, ebx, ebx, ebx, ebx
        mov     [hMainWindow], eax

        invoke  GetClientRect, eax, clientRect
        invoke  ShowCursor, ebx
        invoke  GetTickCount
        mov     [time], eax

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

proc WindowProc uses ebx,\
     hWnd, uMsg, wParam, lParam

        xor     ebx, ebx

        mov     eax, [uMsg]
        JumpIf  WM_PAINT,       .Paint
        JumpIf  WM_DESTROY,     .Destroy
        JumpIf  WM_KEYDOWN,     .KeyDown

        invoke  DefWindowProc, [hWnd], [uMsg], [wParam], [lParam]
        jmp     .Return

.Paint:
        stdcall Draw
        jmp     .ReturnZero
.KeyDown:
        cmp     [wParam], VK_ESCAPE
        jne     .ReturnZero

.Destroy:
        invoke  ExitProcess, ebx

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
 




proc Object.move uses esi, vArr, vCount, x, y, z
        ; esi - 'cause there's no mem to mem mov
        ; vArr - array of vertices to move
        ; vCount - number of those vertices
        ; x, y, z - the dist the obj will be moved

        stdcall Matrix.setDefault

        mov esi, dword[x]
        mov [trMatr.m14], esi
        mov esi, dword[y]
        mov [trMatr.m24], esi 
        mov esi, dword[z] 
        mov [trMatr.m34], esi

        stdcall Matrix.MultOnXYZ1, trMatr, [vArr], [vCount]

        ret     
endp 

; !!!!!!!!!!!!!!!!!!!!!!!!!!!
; When I've figured it out how do I print text, 
; will add here text addr params or smth
proc DrawRect, hasBorder, R, G, B, x1, y1, x2, y2      
        ; hasBorder - either 1 or 0 for xy1xy2 rect border 
        ; R, G, B - colors of the xy1xy2 rect
        ; x1, y1, x2, y2 - coords of xy1xy2 rect 

        locals 
                coord dd ? ; just a temp var for fpu 
        endl

        invoke glColor3f, [R], [G], [B]                 ; setting color
        invoke glRectf, [x1], [y1], [x2], [y2]          ; and drawing main rect, z=0
        
        cmp [hasBorder], 1                              ; checking for border
        jne notSelected                                 ; exit if there's no one

        invoke glColor3f, 1.0, 1.0, 1.0                 ; setting border color

        fld dword[y2]                                   ; calculating border xy's 
        fadd dword[onedd]
        fstp [coord]
        push [coord]

        fld dword[x2]
        fadd dword[onedd]
        fstp [coord]
        push [coord]
        
        fld dword[y1]
        fsub dword[onedd]
        fstp [coord]
        push [coord]

        fld dword[x1] 
        fsub dword[onedd]
        fstp [coord]
        push [coord]

        ; actually this sht above must be optimized using loop and
        ; ebp+N for all coords. For the sake of bytes, I'll do that later 

        invoke glRectf ; all parameters were pushed above


        notSelected:                                    ; exiting when there's no border

        ret
endp


proc Draw
        locals 
                currentTime dd ?
        endl

        stdcall Just.Wait, 30                           

        fld     [waveX]
        fsin    
        fdiv    dword[twodd]
        fdiv    dword[twodd]
        fdiv    dword[twodd]
        fstp    [waveSin]

        fld     [waveX]
        fadd    [waveStep]
        fstp    [waveX]



        stdcall Object.move, seaVertices, [seaPlaneVertCount], 0.0, [waveSin] , 0.0
 
        invoke  glClearColor, 0.1, 0.1, 0.6, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT

        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity

        invoke  gluLookAt, double [CamX],   double [CamY],   double [CamZ],\
                           double [WatchX], double [WatchY], double [WatchZ],\
                           double [UpvecX], double [UpvecY], double [UpvecZ]
 

        stdcall PutObject, skyVertices, skyColors, dword[skyPlaneVertCount]
        stdcall PutObject, seaVertices, seaColors, dword[seaPlaneVertCount]
        stdcall PutObject, sunVertices, sunColors, dword[sunPlaneVertCount]
 
                      ; Brdr  R    G    B    X1   Y1   X2    Y2
        stdcall DrawRect, 0, 0.0, 1.0, 1.0, 25.0, 26.0, 85.0, 43.0
        stdcall DrawRect, 0, 0.0, 0.0, 1.0, 25.0, 3.0, 85.0, 20.0
        stdcall DrawRect, 0, 0.0, 1.0, 0.0, 25.0, -20.0, 85.0, -3.0
        stdcall DrawRect, 1, 1.0, 0.0, 0.0, 25.0, -43.0, 85.0, -26.0
        




        invoke  SwapBuffers, [hdc]

        ret
endp