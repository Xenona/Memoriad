proc Draw.Rect, hasBorder, hasBody, R, G, B, x1, y1, x2, y2      
        ; hasBorder - either 1 or 0 for xy1xy2 rect border 
        ; R, G, B - colors of the xy1xy2 rect
        ; x1, y1, x2, y2 - coords of xy1xy2 rect 

        locals 
                x1m1 dd ?                              ; just a temp var for fpu 
                x2p1 dd ?
                y1m1 dd ?
                y2p1 dd ?
        endl

        cmp  [hasBody], 1
        jne .checkBorder
        invoke glColor3f, [R], [G], [B]                 ; setting color
        invoke glRectf, [x1], [y1], [x2], [y2]          ; and drawing main rect, z=0
        
        .checkBorder:
        cmp byte[hasBorder], 1                          ; checking for border
        jne .notSelected                                 ; exit if there's no one

        invoke glColor3f, 1.0, 1.0, 1.0                 ; setting border color

        fld     dword[x1]
        fsub    [onedd]
        fstp    [x1m1]

        fld     dword[y1]
        fsub    [onedd]
        fstp    [y1m1]

        fld     dword[x2]
        fadd    [onedd]
        fstp    [x2p1]

        fld     dword[y2]
        fadd    [onedd]
        fstp    [y2p1]

        invoke  glRectf, [x1m1], [y1m1], [x1], [y2p1]
        invoke  glRectf, [x1m1], [y2], [x2p1], [y2p1]
        invoke  glRectf, [x2], [y1m1], [x2p1], [y2p1]
        invoke  glRectf, [x1m1], [y1m1], [x2p1], [y1]

         
        .notSelected:                                    ; exiting when there's no border

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


        mov     dword[cameraPos + vector3.x], 0.0
        mov     dword[cameraPos + vector3.y], 0.0
        mov     dword[cameraPos + vector3.z], 90.0

        mov     dword[targetPos + vector3.x], 0.0
        mov     dword[targetPos + vector3.y], 0.0
        mov     dword[targetPos + vector3.z], -100.0

        mov     dword[upVector.x], 0.0
        mov     dword[upVector.y], 1.0
        mov     dword[upVector.z], 0.0
        stdcall Matrix.LookAt, cameraPos, targetPos, upVector
 
        stdcall PutObject, skyVertices, skyColors, dword[skyPlaneVertCount]
        stdcall PutObject, seaVertices, seaColors, dword[seaPlaneVertCount]
        stdcall PutObject, sunVertices, sunColors, dword[sunPlaneVertCount]
 
        stdcall Draw.Text, 35.0, 29.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.StartButton, 0
        stdcall Draw.Text, 27.0, 7.5, 0.0, 1.0, 1.0, 1.0, 0.07, Window0.CardsButton, 0
        stdcall Draw.Text, 28.5, -16.5, 0.0, 1.0, 1.0, 1.0, 0.09, Window0.SettsButton, 0
        stdcall Draw.Text, 43.0, -40.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.ExitButton, 0
        stdcall Draw.Text, -85.0, 37.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.WelcomeText0, 1
        stdcall Draw.Text, -85.0, 23.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.WelcomeText1, 1

        stdcall Draw.Rect, [buttStartBrdr], 1, 0.0, 0.5, 0.5, [buttStartX1], [buttStartY1], [buttStartX2], [buttStartY2]
        stdcall Draw.Rect, [buttCardsBrdr], 1, 0.0, 0.5, 0.5, [buttCardsX1], [buttCardsY1], [buttCardsX2],  [buttCardsY2]
        stdcall Draw.Rect, [buttSettsBrdr], 1, 0.0, 0.5, 0.5, [buttSettsX1], [buttSettsY1], [buttSettsX2], [buttSettsY2]
        stdcall Draw.Rect, [buttExitBrdr],  1, 0.0, 0.5, 0.5, [buttExitX1],  [buttExitY1],  [buttExitX2],  [buttExitY2] 

        invoke  SwapBuffers, [hdc]


        ret
endp


proc Draw.Window1
        locals
                x1 dd 0 
                x2 dd 0
                y1 dd 0
                y2 dd 0 
        endl
        invoke  glClearColor, 0.05, 0.1, 0.2, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity
  
        fld     [camAngle]                                              ; calculating init pos and target of a camera
        fcos    
        fmul    [camViewRadius]
        fstp    [cameraPos.z]

        fld     [camAngle]
        fsin 
        fmul    [camViewRadius]
        fadd    [cardHeight]
        fadd    [cardHeight]
        fadd    [marginY]
        fstp    [cameraPos.y]

        fld     [cardWidth]
        fadd    [marginX]
        fmul    [fivedd]
        fld     [marginX]
        fdiv    [twodd]
        fsubp 
        fld     [cardWidth]
        fdiv    [twodd]
        fsubp
        fst     [cameraPos.x]
        fstp    [targetPos.x]

        fld     [cardHeight]
        fadd    [marginY]
        fmul    [twodd]
        fld     [marginY]
        fdiv    [twodd]
        fsubp
        fstp    [targetPos.y]

        mov     [targetPos.z], 0.0

        stdcall Matrix.LookAt, cameraPos, targetPos, upVector           ; applying calculated values
        invoke glPushMatrix                                             

        mov ebx, card1X1
        mov edi, cardMatrix
        mov esi, 0
        .DrawRows: 
        invoke glPushMatrix
        fld     [y2]
        fadd    [cardHeight]
        fstp    [y2]
        push esi
        
        fld     [cardWidth]
        fadd    [fivedd]
        fst     [x1]
        fstp    [x2]

                mov esi, 0
                .DrawCols:



                        fld     [x1]
                        fst     dword[ebx]
                        fadd    [cardWidth]
                        fadd    [marginX]
                        
                        fstp    [x1]

                        fld     [y1]
                        fstp    dword[ebx+4]

                        fld     [x2]
                        fadd    [cardWidth]
                        fst     dword[ebx+8]
                        fadd    [marginX]
                        fstp    [x2]

                        fld     [y2]
                        fstp    dword[ebx+12]

                        invoke glTranslatef, [cardWidth], 0.0, 0.0
                        invoke glTranslatef, [marginX], 0.0, 0.0
                        invoke glPushMatrix

                        xor     eax, eax
                        movzx   eax, byte[edi]
                        case    0,      .CardState0
                        case    1,      .CardState1
                        case    2,      .CardState2
                        case    3,      .CardState3
                        case    4,      .CardState4

                        .CardState0:

                        jmp .EndInnerLoop

                        .CardState1:
                                invoke glRotatef, 180.01, 0.0, 42.0, 0.0



                        jmp .EndInnerLoop
                        .CardState2:
                                fld     [cardRotCurrAng]                ; alpha
                                fadd    [cardRotAngStep]                ; a+step
                                fst     [cardRotCurrAng]                ; a+step => a
                                fld     [cardRotStopAng]                ; stopAngle 
                                fcompp                                  ; a+step < stopAngle? 
                                fstsw   ax                              
                                shr     ax, 9                           ; if c=1 it's true, otherwise it's false
                                jc      @f 

                                        invoke glRotatef, [cardRotCurrAng], 0.0, 42.0, 0.0

                                jmp .exitAngleCheck
                                @@:
                                        mov     [cardRotCurrAng], 0
                                        mov     byte[edi], 3
                                
                                .exitAngleCheck: 





                        jmp .EndInnerLoop

                        .CardState3:
                                invoke glRotatef, 180.0, 0.0, 42.0, 0.0
                        jmp .EndInnerLoop

                        .CardState4:
                                fld     [cardMinusRotCurrAng]                ; alpha
                                fadd    [cardRotAngStep]                ; a+step
                                fst     [cardMinusRotCurrAng]                ; a+step => a
                                fld     [cardMinusRotStopAng]                ; stopAngle 
                                fcompp                                  ; a+step < stopAngle? 
                                fstsw   ax                              
                                shr     ax, 9                           ; if c=1 it's true, otherwise it's false
                                jc      @f 

                                        invoke glRotatef, [cardMinusRotCurrAng], 0.0, 42.0, 0.0

                                jmp .exitAngleCheck4
                                @@:
                                        mov     [cardMinusRotCurrAng], 180.1 
                                        mov     byte[edi], 0
                                        dec     [numOfCurrOpened]
                                
                                .exitAngleCheck4: 






                        jmp .EndInnerLoop

                    
                        .EndInnerLoop:

                        stdcall PutObject, cardVertices, cardColors, [CardVertCount]
                        invoke glPopMatrix


                add ebx, 16
                add edi, 1
                inc esi
                cmp esi, 8
                jne .DrawCols

        fld     [y2]
        fadd    [marginY]
        fstp    [y2]
        fld     [y1]
        fadd    [cardHeight]
        fadd    [marginY]
        fstp    [y1]
        


        invoke glPopMatrix
        invoke glTranslatef, 0.0, [cardHeight], 0.0 
        invoke glTranslatef, 0.0, [marginY], 0.0 

 
        pop esi

        inc esi 
        cmp esi, 4
        jne .DrawRows 
        invoke glPopMatrix

        mov ebx, 0
        @@:
                cmp [card1BrdrHandler+ebx], 1
                jne .skip 
                
                mov eax, ebx 
                mul [four]
                mov esi, eax

                stdcall Draw.Rect, [card1BrdrHandler+ebx], 0, 0, 0, 0, [card1X1+esi], [card1X1+esi+4], [card1X1+esi+8], [card1X1+esi+12] 

                jmp .exitDrawingBoard 
        .skip:
        add ebx, 4
        cmp ebx, 128
        jne @b

 
        .exitDrawingBoard:
        invoke  SwapBuffers, [hdc]

        ret
endp