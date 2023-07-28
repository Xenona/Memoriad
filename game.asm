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

struct matrix
        m11     dd      ? 
        m12     dd      ? 
        m13     dd      ? 
        m14     dd      ? 

        m21     dd      ? 
        m22     dd      ? 
        m23     dd      ? 
        m24     dd      ? 

        m31     dd      ? 
        m32     dd      ? 
        m33     dd      ? 
        m34     dd      ? 

        m41     dd      ? 
        m42     dd      ? 
        m43     dd      ? 
        m44     dd      ? 
ends

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


; proc Object.wave uses ebx esi ecx, vertArray:DWORD, vCount:DWORD, axis:WORD
;         ; waves camera by 2sin(x) !!!!!!!!!!!!!!!!!!!!!

;         ; x is stored in waveAxisX,
;         ; its step - in waveXStep (suddenly)

;         ; fld     [waveAxisX]             ; load curr X
;         ; fsin                            ; sin(x)
;         ; fmul    [two]                   ; 2*sin(x)
;         ; fstp    [CamY]                  ; 2*sin(x) -> camY
;         xor ebx, ebx
;         xor esi, esi

;         mov esi, [vertArray]

;         mov ebx, dword[axis] ; 1,  2 or 3
;         @@:
;         ;       fld       [waveXStep]
;         ;       fld       [waveAxisX]
;         ;       fsub      st1, st0
;         ;       fld       dword[esi + ebx]
;         ;       fld       st1
;         ;       fsin 
;         ;       fsubp                 



;         ;       fxch





                

;         add ebx, 3
;         cmp ebx, [vCount]
;         jbe @b 

;         fld     [waveAxisX]             ; load curr X
;         fadd    [waveXStep]             ; X+step 
;         fstp   [waveAxisX]             ; X+step -> X 

;         ret 
; endp

proc Object.move uses esi ebx, vArr, vCount, x, y, z
        locals
                translMatr matrix 
        endl

        mov [translMatr.m11], 1.0 
        mov [translMatr.m22], 1.0
        mov [translMatr.m33], 1.0
        mov [translMatr.m44], 1.0

        mov esi, dword[x]
        mov [translMatr.m14], esi
        mov esi, dword[y]
        mov [translMatr.m24], esi 
        mov esi, dword[z] 
        mov [translMatr.m34], esi

        lea ebx, translMatr

        stdcall Matrix.MultOnXYZ1,  [vArr]

        ret     
endp 




proc Draw
        locals 
                currentTime dd ?
        endl

        stdcall Just.Wait, 20

        ; stdcall Camera.wave ; object
        stdcall Object.move, seaVertices, SeaPlaneVertCount, 1, 2, 3

        ; FOR ROTATE
        fld     [angle]
        fsub    [step]
        fstp    [angle]
        ; invoke  glRotatef, [angle], 0.0, 1.0, 0.0
        ; ROTATE FOR


        invoke  glClearColor, 0.1, 0.1, 0.6, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT

        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity

        invoke  gluLookAt, double [CamX], double [CamY], double [CamZ],\
                           double [WatchX], double [WatchY], double [WatchZ],\
                           double [UpvecX], double [UpvecY], double [UpvecZ]
 

        stdcall PutObject, skyVertices, skyColors, dword[SkyPlaneVertCount]
        stdcall PutObject, seaVertices, seaColors, dword[SeaPlaneVertCount]


        invoke  SwapBuffers, [hdc]

        ret
endp