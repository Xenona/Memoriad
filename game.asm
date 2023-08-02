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


        

        
        include ".\DATA\CameraVariables.inc"
        params matrix
        aspect          dq      ?



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

                stdcall On.Hover, 4, buttStartX1, buttStartBrdr, [mouseX], [mouseY]

                cvtss2si eax, [buttStartX1]

                cmp [mouseX], eax 
                jle .set1
                .set0:
                mov [buttStartBrdr], 0
                jmp .ReturnZero
                .set1:
                mov [buttStartBrdr], 1

                
                



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

                currMode        dd ?
                nop
                nop
                nop
                nop
                nop
                matrixWtS matrix

proc WorldToScreen uses esi ecx, worldX, worldY, worldZ      
; shall return 3 params via registers: 
                        ; screenX, Y and Z

        locals 
                currX           dd ?
                currY           dd ?
                currZ           dd ?
        endl

        ; get projection matrix
        ; get view matrix 
        ; get vector matrix 

        ; get M(x, y, z, w) = proj*view*vect

        ; get M = M(x/w, y/w, z/w)

        ; get screenX = (M[0]+1.0) * screenWidth * 0.5
        ; get screenY = (1.0 - M[1]) * screenHeight * 0.5
        ; get screenZ = (M[2] + 1.0) * 0.5




        invoke glGetFloatv, GL_MATRIX_MODE, currMode 
        invoke glMatrixMode, GL_PROJECTION


        invoke glPushMatrix
        invoke glLoadIdentity 

        invoke gluPerspective, double FOV, double [aspect], double Z_NEAR, double Z_FAR

      



        invoke  gluLookAt, double [CamX],   double [CamY],   double [CamZ],\
                        double [WatchX], double [WatchY], double [WatchZ],\
                        double [UpvecX], double [UpvecY], double [UpvecZ]
        ; that's proj*view already, according to the docs matrix 
        ; matrix of gluPerspective is being multiplied with
        ; current matrix 

        stdcall Matrix.setDefault, matrixWtS
        mov edi, [worldX]
        mov [matrixWtS.m41], edi
        mov edi, [worldY]
        mov [matrixWtS.m42], edi
        mov edi, [worldZ]
        mov [matrixWtS.m43], edi
        
        invoke glMultMatrixf, matrixWtS
        invoke glGetFloatv, GL_PROJECTION_MATRIX, matrixWtS

        fld [matrixWtS.m41]
        fdiv [matrixWtS.m44]
        fadd [onedd]
        fmul [clientRect.right]
        fdiv [twodd]
        fstp [currX]


        fld [matrixWtS.m42]
        fdiv [matrixWtS.m44]
        fchs 
        fadd [onedd]
        fmul [clientRect.bottom]
        fdiv [twodd]
        fstp [currY]

        fld [matrixWtS.m43]
        fdiv [matrixWtS.m44]
        fadd [onedd]
        fdiv [twodd]
        fstp [currZ]



        invoke glPopMatrix
        invoke glMatrixMode, [currMode]

        mov eax, [currX]
        mov edx, [currY]
        mov edi, [currZ]



        ret 
endp 


proc On.Hover uses ecx ebx esi edi edx eax , numOfObjs, objArr, brdrHandler, x, y

        locals 

        endl

        xor ecx, ecx

        mov ebx, [objArr]
        mov esi, [brdrHandler]

        mov ecx, [numOfObjs]
        @@: 
                nop
                nop
                nop
                stdcall WorldToScreen, dword[ebx], dword[ebx+4], dword[ebx+8]
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

        stdcall Matrix.setDefault, trMatr
        


        mov esi, dword[x]
        mov [trMatr.m14], esi
        mov esi, dword[y]
        mov [trMatr.m24], esi 
        mov esi, dword[z] 
        mov [trMatr.m34], esi

        stdcall Matrix.MultOnXYZ1, trMatr, [vArr], [vCount]

        ret     
endp 
