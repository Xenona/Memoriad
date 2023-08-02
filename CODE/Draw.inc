
; !!!!!!!!!!!!!!!!!!!!!!!!!!!
; Once I've figured it out how do I print text, 
; will add here text addr params or smth
proc Draw.Rect, hasBorder, R, G, B, x1, y1, x2, y2      
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


proc Draw.Window0
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
 
        stdcall Draw.Rect, [buttStartBrdr], 0.0, 1.0, 1.0, dword[buttStartX1], dword[buttStartY1], dword[buttStartX2], dword[buttStartY2]
        stdcall Draw.Rect, [buttViewBrdr], 0.0, 0.0, 1.0, dword[buttViewX1], dword[buttViewY1], dword[buttViewX2], dword[buttViewY2]
        stdcall Draw.Rect, [buttSettsBrdr], 0.0, 1.0, 0.0, dword[buttSettsX1], dword[buttSettsY1], dword[buttSettsX2], dword[buttSettsY2]
        stdcall Draw.Rect, [buttExitBrdr], 1.0, 0.0, 0.0, dword[buttExitX1], dword[buttExitY1], dword[buttExitX2], dword[buttExitY2] 
        




        invoke  SwapBuffers, [hdc]

        ret
endp