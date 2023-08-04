proc Draw.Rect, hasBorder, R, G, B, x1, y1, x2, y2      
        ; hasBorder - either 1 or 0 for xy1xy2 rect border 
        ; R, G, B - colors of the xy1xy2 rect
        ; x1, y1, x2, y2 - coords of xy1xy2 rect 

        locals 
                coord dd ? ; just a temp var for fpu 
        endl

        invoke glColor3f, [R], [G], [B]                 ; setting color
        invoke glRectf, [x1], [y1], [x2], [y2]          ; and drawing main rect, z=0
        
        cmp byte[hasBorder], 1                          ; checking for border
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

 
proc Draw.Text uses ecx eax edx edi, x, y, z, R, G, B, fontSize, stringPtr, isBold
        locals
                linearTerm      dd      177.2
                constantTerm    dd      1.5
                lineWidth       dd      ?
        endl
        ; eax, edx - to preserve their changing in outer procedures 'cause of gl procs
        ; ecx - for string output loop.
        ; x, y, z - position of the first letter of the text.
        ; R, G, B - color of the text being printed.
        ; fontSize - float used in scale matrix. Displays relative size of font.
        ; stringPtr - pointer to a null-terminated C-string.
        
        ; I found a correlation between size of a letter (x) and its
        ; line width (y), that resulted in such an equation:
        ;
        ;                    y = 177.2*x + 1.5
        ;
        ; No need to specify which points I originally had, 
        ; 'cause there was no fancy mathematics, I just liked
        ; the way a certain proportion looked like. 

        invoke glGetFloatv, GL_MATRIX_MODE, currMode    ; saving old mode (IN QUESTION)
        invoke glPushMatrix                             ; saving matrix stack state

        fld dword[fontSize]                             ; following the aforementioned equation
        fmul [linearTerm]
        fadd [constantTerm]
        
        cmp [isBold], 1
        jne @f
        fadd [fivedd]
        @@:
        fstp [lineWidth]
                
        invoke glLineWidth, [lineWidth]                 
        invoke glTranslatef, [x], [y], [z]
        invoke glScalef, [fontSize], [fontSize], [fontSize]
        invoke glColor3f, [R], [G], [B]                        

        mov edi, [stringPtr]
        @@:
                movzx eax, byte[edi]
                cmp eax, 0
                je .break
                invoke glutStrokeCharacter, GLUT_STROKE_ROMAN, eax
                inc edi
        jmp @b

        .break:
       
        invoke glPopMatrix
        invoke glMatrixMode, [currMode]                                         ; restoring old mode 
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
 
        stdcall Draw.Text, 35.0, 29.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.StartButton, 0
        stdcall Draw.Text, 27.0, 7.5, 0.0, 1.0, 1.0, 1.0, 0.07, Window0.CardsButton, 0
        stdcall Draw.Text, 28.5, -16.5, 0.0, 1.0, 1.0, 1.0, 0.09, Window0.SettsButton, 0
        stdcall Draw.Text, 43.0, -40.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.ExitButton, 0
        stdcall Draw.Text, -85.0, 37.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.WelcomeText0, 1
        stdcall Draw.Text, -85.0, 23.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.WelcomeText1, 1

        stdcall Draw.Rect, [buttStartBrdr], 0.0, 0.5, 0.5, [buttStartX1], [buttStartY1], [buttStartX2], [buttStartY2]
        stdcall Draw.Rect, [buttCardsBrdr], 0.0, 0.5, 0.5, [buttCardsX1], [buttCardsY1], [buttCardsX2],  [buttCardsY2]
        stdcall Draw.Rect, [buttSettsBrdr], 0.0, 0.5, 0.5, [buttSettsX1], [buttSettsY1], [buttSettsX2], [buttSettsY2]
        stdcall Draw.Rect, [buttExitBrdr],  0.0, 0.5, 0.5, [buttExitX1],  [buttExitY1],  [buttExitX2],  [buttExitY2] 

        invoke  SwapBuffers, [hdc]


        ret
endp