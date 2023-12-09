proc Draw.Rect, hasBorder, hasBody, R, G, B, x1, y1, x2, y2, thickness      
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
        fsub    [thickness]
        fstp    [x1m1]

        fld     dword[y1]
        fsub    [thickness]
        fstp    [y1m1]

        fld     dword[x2]
        fadd    [thickness]
        fstp    [x2p1]

        fld     dword[y2]
        fadd    [thickness]
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
        stdcall Texture.Unbind, GL_TEXTURE_2D, 0


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
 
        stdcall PutObject, skyVertices, skyColors, dword[skyPlaneVertCount], 0, 0, 0
        stdcall PutObject, seaVertices, seaColors, dword[seaPlaneVertCount], 0, 0, 0
        stdcall PutObject, sunVertices, sunColors, dword[sunPlaneVertCount], 0, 0, 0
 
        stdcall Draw.Text, 35.0, 29.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.StartButton, 0
        stdcall Draw.Text, 27.0, 7.5, 0.0, 1.0, 1.0, 1.0, 0.07, Window0.CardsButton, 0
        stdcall Draw.Text, 28.5, -16.5, 0.0, 1.0, 1.0, 1.0, 0.09, Window0.SettsButton, 0
        stdcall Draw.Text, 43.0, -40.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.ExitButton, 0
        stdcall Draw.Text, -85.0, 37.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.WelcomeText0, 1
        stdcall Draw.Text, -85.0, 23.0, 0.0, 1.0, 1.0, 1.0, 0.1, Window0.WelcomeText1, 1

        stdcall Draw.Rect, [buttStartBrdr], 1, 0.0, 0.5, 0.5, [buttStartX1], [buttStartY1], [buttStartX2], [buttStartY2], [onedd]
        stdcall Draw.Rect, [buttCardsBrdr], 1, 0.0, 0.5, 0.5, [buttCardsX1], [buttCardsY1], [buttCardsX2],  [buttCardsY2], [onedd]
        stdcall Draw.Rect, [buttSettsBrdr], 1, 0.0, 0.5, 0.5, [buttSettsX1], [buttSettsY1], [buttSettsX2], [buttSettsY2], [onedd]
        stdcall Draw.Rect, [buttExitBrdr],  1, 0.0, 0.5, 0.5, [buttExitX1],  [buttExitY1],  [buttExitX2],  [buttExitY2], [onedd]

        invoke  SwapBuffers, [hdc]


        ret
endp


proc Draw.Window1
        locals
                x1 dd 0 
                x2 dd 0
                y1 dd 0
                y2 dd 0 
                cardRotCurrAng dd 0
                pointerCardAng dd 0
                numberOf3      dd 0                   ; UP TO 2 
                numberOf234    dd 0                   ; UP TO 2
                currTime       dd 0
        endl
        invoke  glClearColor, 0.05, 0.1, 0.2, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity
  
        cmp     [numOfGuessedPairs], 16
        je      .GameFinished
                                                        ; calculating init pos and target of a camera
        fld     [camAngle]                                              
        fcos    
        fmul    [camViewRadius]
        fstp    [cameraPos.z]                           ; cos(camAngle)*R -> cameraPos.z

        fld     [camAngle]                              
        fsin 
        fmul    [camViewRadius]
        fadd    [cardHeight]
        fadd    [cardHeight]
        fadd    [marginY]
        fstp    [cameraPos.y]                           ; sin(camAngle)*R + 2*cardHeight + marginY -> cameraPos.y

        fld     [cardWidth]
        fadd    [marginX]
        fmul    [fivedd]
        fld     [marginX]
        fdiv    [twodd]
        fsubp 
        fld     [cardWidth]
        fdiv    [twodd]
        fsubp
        fst     [cameraPos.x]                           ; (cardWidth+marginX)*5 - (marginX-cardWidth)/2 -> cameraPos.x
        fstp    [targetPos.x]                           ;                                               -> targetPos.x

        fld     [cardHeight]
        fadd    [marginY]
        fmul    [twodd]
        fld     [marginY]
        fdiv    [twodd]
        fsubp
        fstp    [targetPos.y]                           ; (cardHeight+marginY)*2 - marginY/2 -> targetPos.y

        mov     [targetPos.z], 0.0


        ; fld     [cameraPos.x]
        ; fsub    [targetPos.x]
        ; fdiv    [camViewRadius]
        ; fstp    [upVector.x]

        ; fld     [cameraPos.y]
        ; fsub    [targetPos.y]
        ; fdiv    [camViewRadius]
        ; fstp    [upVector.y]

        ; fld     [cameraPos.z]
        ; fsub    [targetPos.z]
        ; fdiv    [camViewRadius]
        ; fstp    [upVector.z]

        ; DEBUG
        ; fld     [camAngle]
        ; fadd    [camAngleStep]
        ; fstp    [camAngle]

        stdcall Matrix.LookAt, cameraPos, targetPos, upVector           ; applying calculated values
        invoke glPushMatrix                                             

        mov ebx, card1X1
        mov edi, cardStateMatrix
        mov esi, 0
        .DrawRows: 
        invoke glPushMatrix
        fld     [y2]
        fadd    [cardHeight]
        fld     [onedd]
        fdiv    [fourdd]
        fdiv    [fourdd]
        fsubp
        fstp    [y2]
        push esi
        
        fld     [cardWidth]
        fld     [onedd]
        fdiv    [twodd]
        faddp
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
                                inc [numberOf234]
                               
                                ; int index = getCurrCard();                            (1)
                                ; cardAngleMatrix[index] += step;                       (2)
                                ; if (cardAngleMatrix[index] < cardRotStopAng) {
                                ;         rotate();
                                ; } else {
                                ;         cardStateMatrix[index] = 3;
                                ; }
                                mov eax, edi
                                sub eax, cardStateMatrix                            ; (1) index === eax

                                shl eax, 2
                                add eax, cardAngleMatrix          
                                fld dword[eax]
                                fadd [cardRotAngStep]
                                fst dword[eax]                                      ; (2)
                                fld     [cardRotStopAng] 
 
                                push eax
                                fcompp                                  ; a+step < stopAngle? 
                                fstsw   ax                              
                                shr     ax, 9                           ; if c=1 it's true, otherwise it's false
                                pop eax
                                jc      @f 

                                        invoke glRotatef, dword[eax], 0.0, 42.0, 0.0

                                jmp .exitAngleCheck
                                @@:
                                        mov     byte[edi], 3

                                
                                .exitAngleCheck: 




                        jmp .EndInnerLoop

                        .CardState3:
                                inc [numberOf3]
                                inc [numberOf234]
                                invoke glRotatef, 180.0, 0.0, 42.0, 0.0
                        jmp .EndInnerLoop

                        .CardState4:
                                inc [numberOf234]

                                ; int index = getCurrCard();
                                ; cardAngleMatrix[index] += step;
                                ; if (cardAngleMatrix[index] < cardMinusRotStopAng) {
                                ;         rotate();
                                ; } else {
                                ;         cardAngleMatrix[index] = 0;
                                ;         cardStateMatrix[index] = 0;
                                ;         dec [numOfCurrOpened];
                                ;         if (index == cardsSelected[0]) {
                                ;                 cardsSelected[0] = -1;
                                ;         } else
                                ;         if (index == cardsSelected[1]) {
                                ;                 cardsSelected[1] = -1;
                                ;         }
                                ; }

                                mov eax, edi
                                sub eax, cardStateMatrix                            ; (1) index === eax

                                shl eax, 2
                                add eax, cardAngleMatrix          
                                fld dword[eax]
                                fadd [cardRotAngStep]
                                fst dword[eax]                                      ; (2)
                                fld     [cardMinusRotStopAng] 
                                push eax
                                fcompp                                          ; a+step < stopAngle? 
                                fstsw   ax                              
                                shr     ax, 9                                   ; if c=1 it's true, otherwise it's false
                                pop eax
                                jc      @f 

                                        invoke glRotatef, dword[eax], 0.0, 42.0, 0.0
                                        

                                jmp .exitAngleCheck4
                                @@:
                                        mov     dword[eax], 0
                                        mov     byte[edi], 0
                                        dec     [numOfCurrOpened]


                                        sub eax, cardAngleMatrix
                                        shr eax, 2      
                                        .firstCardClosed:
                                        cmp eax, [cardsSelected]
                                        jne .secondCardClosed
                                                mov [cardsSelected], -1
                                        jmp @f;
                                        .secondCardClosed:

                                                mov [cardsSelected+4], -1

                                        @@:



                                        ;alert xena

                                        ; if (cardsSelected[0] == -1) {
                                        ;         if (cardsSelected[1] == -1) {
                                        ;                 canClick = 1;
                                        ;         }
                                        ; }


                                        ; cmp [cardsSelected], -1
                                        ; jne .exitAngleCheck4
                                        ; cmp [cardsSelected + 4], -1
                                        ; jne .exitAngleCheck4
                                        ; mov [canClick], 1

                                        
                                
                                .exitAngleCheck4: 
                        jmp .EndInnerLoop

                    
                        .EndInnerLoop:

                        push edi
                        sub edi, cardStateMatrix
                        shl edi, 2
                        
                        mov eax, dword[edi+arrTextures]


                        ; push eax 
                        ; stdcall PutObject, cardFace, 0, NUM_OF_VERTS_FOR_CARD_FACE, 1, dword[cardBackTexHandle], edi
                        ; stdcall PutObject, cardBack, 0, NUM_OF_VERTS_FOR_CARD_BACK, 1, dword[arrTextures], cardTextures
                        ; pop eax
                        ; stdcall PutObject, cardVertices, cardColors, NUM_OF_VERTS_FOR_CARD_BORDERS, 0, 0, 0
                        
                        invoke glColor3f, 1.0, 1.0, 1.0 
                        stdcall PutObject, cardFace, cardColors, NUM_OF_VERTS_FOR_CARD_FACE, 1, dword[cardBackTexHandle], cardTextures
                        stdcall PutObject, cardBack, cardColors, NUM_OF_VERTS_FOR_CARD_BACK, 1, dword[edi+arrTextures], cardTextures
                        stdcall PutObject, cardVertices, cardColors, NUM_OF_VERTS_FOR_CARD_BORDERS, 0, 0, 0
                        pop edi
                        
                        
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

        cmp [numberOf3], 2
        jb @f 

        
        ; if (cardsMatch) {
        ;         cardStateMatrix[cardsSelected[0]] = 1;
        ;         cardStateMatrix[cardsSelected[1]] = 1;
        ;         numOfCurrOpened = 0;
        ;         cardsSelected[0] = -1;
        ;         cardsSelected[1] = -1;
        ;         canClick = 1;
        ; } else {
        ;         if (timeOfStart = -1) {
        ;                 timeOfStart = getTime();
        ;         } else {
        ;                 int currTime = getTime();
        ;                 int diff = currTime - timeOfStart;
        ;                 if (diff >= timeToWait) {
        ;                         cardStateMatrix[cardsSelected[0]] = 4;
        ;                         cardStateMatrix[cardsSelected[1]] = 4;
        ;                         timeOfStart = -1;
        ;                 }
        ;         }
        ; }

        mov ebx, [cardsSelected]
        .cardsMatching:
        cmp dword[cardsMatch], 1
        jne .cardsDontMatch

        mov byte[ebx + cardStateMatrix], 1
        mov ebx, [cardsSelected + 4]
        mov byte[ebx + cardStateMatrix], 1
        mov [numOfCurrOpened], 0
        mov [cardsSelected], -1;
        mov [cardsSelected+4], -1;
        mov [canClick], 1



        jmp .skipskip
        .cardsDontMatch:        
        ;;
                cmp [timeOfStart], -1
                jne .checkTimeLeft
                        invoke GetTickCount
                        mov [timeOfStart], eax
                jmp .skipskip
                .checkTimeLeft:
                invoke GetTickCount
                sub eax, [timeOfStart]
                cmp eax, [timeToWait]
                jb .skipskip



                mov byte[ebx + cardStateMatrix], 4
                mov ebx, [cardsSelected + 4]
                mov byte[ebx + cardStateMatrix], 4
                mov [timeOfStart], -1
        ;;
        .skipskip:



        jmp .handleBorders

        @@: 

        cmp [numberOf234], 2
        jb @f 

        mov [canClick], 0 
        jmp .handleBorders
        @@:
        mov [canClick], 1

        .handleBorders:
        mov ebx, 0
        @@:
                cmp [card1BrdrHandler+ebx], 1
                jne .skip 
                
                mov eax, ebx 
                mul [four]
                mov esi, eax

                stdcall Draw.Rect, [card1BrdrHandler+ebx], 0, 0.0, 0.5, 0.5, [card1X1+esi], [card1X1+esi+4], [card1X1+esi+8], [card1X1+esi+12], [onedd] 


                jmp .exitDrawingBoard
        .skip:
        add ebx, 4
        cmp ebx, 128
        jne @b

 
        .exitDrawingBoard:
        invoke  SwapBuffers, [hdc]
        jmp @f
        .GameFinished:

                mov [windowID], 4


        @@:

        ret
endp

proc Draw.Window2 

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
        invoke glColor3f, 1.0, 1.0, 1.0 



        invoke  SwapBuffers, [hdc]

        ret
endp
proc Draw.Window4


        invoke  glClearColor, 0.05, 0.1, 0.2, 1.0
        invoke  glClear, GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT
        invoke  glMatrixMode, GL_MODELVIEW
        invoke  glLoadIdentity

        invoke glColor3f, 1.0, 1.0, 1.0 
        stdcall Texture.Unbind, GL_TEXTURE_2D, 0

        mov     dword[cameraPos + vector3.x], 0.0
        mov     dword[cameraPos + vector3.y], 0.0
        mov     dword[cameraPos + vector3.z], 90.0

        mov     dword[targetPos + vector3.x], 0.0
        mov     dword[targetPos + vector3.y], 0.0
        mov     dword[targetPos + vector3.z], 0.0

        mov     dword[upVector.x], 0.0
        mov     dword[upVector.y], 1.0
        mov     dword[upVector.z], 0.0
        stdcall Matrix.LookAt, cameraPos, targetPos, upVector

        stdcall Draw.Text, -78.0, 30.0, 0, 1.0, 1.0, 1.0, 0.07, Window2.Congrats, 1
        stdcall Draw.Text, -18.0, 20.0, 0, 1.0, 1.0, 1.0, 0.07, Window2.ItTook, 1

        mov ecx, 18
        mov edi, Window2.Number
        mov eax, ' '
        rep stosb
        stdcall String.IntToStr, dword[numOfTriedPairs], Window2.Number, 0
        stdcall Draw.Text, 0.0, 10.0, 0, 1.0, 1.0, 1.0, 0.07, Window2.Number, 1
        stdcall Draw.Text, -56.0, 0.0, 0, 1.0, 1.0, 1.0, 0.07, Window2.MovesToWin, 1


        cmp dword[numOfTriedPairs], 16
        jle best
        cmp dword[numOfTriedPairs], 50
        jle nice
        cmp dword[numOfTriedPairs], 80
        jle well 
        mov edi, Window2.Custom3
        jmp @f
        
        best:
        mov edi, Window2.Custom0
        jmp @f

        well: 
        mov edi, Window2.Custom1
        jmp @f 

        nice:
        mov edi, Window2.Custom2
        jmp @f

        @@:
        stdcall Draw.Text, -84.0, -20.0, 0, 1.0, 1.0, 1.0, 0.06, edi, 1
        mov eax, dword[numOfTriedPairs]

        stdcall Draw.Text, -90.0, -50.0, 0, 1.0, 1.0, 1.0, 0.05, Window2.ExitHint, 1

        invoke  SwapBuffers, [hdc]

        ret
endp