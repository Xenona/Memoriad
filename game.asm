format  PE GUI 5.0
entry   WinMain

        include         ".\INCLUDE\win32ax.inc"         ; himxrmnski 

        include         ".\INCLUDE\api\kernel32.inc"    ;)
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
                glu32,          "GLU32.DLL"

end data

        className       db      "MEMORIAD (C) XENONA GAMES 2023", 0
        clientRect      RECT
        hdcBack         dd      ?
        hdc             dd      ?


        windowID        db    0

        ; main menu 
        buttStartX1   dd      25.0    
        buttStartY1   dd      26.0
        buttStartZ1    dd        0.0

        buttStartX2   dd      85.0
        buttStartY2   dd      43.0
        buttStartZ2    dd        0.0

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


        

        
        include "CameraVariables.inc"
        include "Matrix.inc"
        params matrix



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


        ; invoke  glPushMatrix
        ; invoke  glMultMatrixf, params 
        ; invoke  glMultMatrixf, params2
        ; invoke  glGetFloatv, GL_PROJECTION_MATRIX, params
        ; invoke  glPopMatrix
        


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

        locals 

                mouseX  dd ? 
                mouseY  dd ?
        endl

        

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
                stdcall DrawWindow0
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

                stdcall On.Hover, 4, buttStartX1, buttStartBrdr, [mouseX], [mouseY]

                ; cvtss2si eax, [buttStartX1]

                ; cmp [mouseX], eax 
                ; jle .set1
                ; .set0:
                ; mov [buttStartBrdr], 0
                ; jmp .ReturnZero
                ; .set1:
                ; mov [buttStartBrdr], 1

                
                



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


proc WorldToScreen worldX, worldY, worldZ      
; shall return 3 params via registers: 
                        ; screenX, Y and Z

        ; get projection matrix
        ; get view matrix 
        ; get vector matrix 

        ; get M(x, y, z, w) = proj*view*vect

        ; get M = M(x/w, y/w, z/w)

        ; get screenX = (M[0]+1.0) * screenWidth * 0.5
        ; get screenY = (1.0 - M[1]) * screenHeight * 0.5
        ; get screenZ = (M[2] + 1.0) * 0.5

        ; check for intersection, but later, it's 2a.m.

        invoke glPushMatrix
        invoke glLoadIdentity 
        invoke  gluLookAt, double [CamX],   double [CamY],   double [CamZ],\
                        double [WatchX], double [WatchY], double [WatchZ],\
                        double [UpvecX], double [UpvecY], double [UpvecZ]
        invoke gluPerspective, double FOV, double [aspect], double Z_NEAR, double Z_FAR
        ; that's proj*view already 

        invoke glPopMatrix

        ret 
endp 

proc On.Hover uses ecx ebx esi edi edx eax , numOfObjs, objArr, brdrHandler, x, y

        locals 

        endl

        xor ecx, ecx

        mov ebx, [objArr]
        mov esi, [brdrHandler]

        mov ecx, numOfObjs
        @@: 
                stdcall [ebx], [ebx+4], [ebx+8]
                ; eax, edx, edi 

                ; check whether xy got inside 


                add esi, 4
                add ebx, 12



        loop @b

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
; Once I've figured it out how do I print text, 
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
        
        cmp byte[hasBorder], 1                              ; checking for border
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


proc DrawWindow0
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
 
        stdcall DrawRect, [buttStartBrdr], 0.0, 1.0, 1.0, dword[buttStartX1], dword[buttStartY1], dword[buttStartX2], dword[buttStartY2]
        stdcall DrawRect, [buttViewBrdr], 0.0, 0.0, 1.0, dword[buttViewX1], dword[buttViewY1], dword[buttViewX2], dword[buttViewY2]
        stdcall DrawRect, [buttSettsBrdr], 0.0, 1.0, 0.0, dword[buttSettsX1], dword[buttSettsY1], dword[buttSettsX2], dword[buttSettsY2]
        stdcall DrawRect, [buttExitBrdr], 1.0, 0.0, 0.0, dword[buttExitX1], dword[buttExitY1], dword[buttExitX2], dword[buttExitY2] 
        




        invoke  SwapBuffers, [hdc]

        ret
endp