
org 100h



; ------------------------------- START

bOldMode db ?
bOldPage db ?



EntryPoint:

    mov ah, $0F
    int 10h
    mov [bOldMode], al
    mov [bOldPage], bh
    mov ax, $0013
    int 10h


;   randomize
    call Random.Initialize

    ; выбираем рандомный цвет


   
    push $A000
    pop es
 

    push [BGCOLOR]
    call Screen.Clear

    ; push 0 255
    ; call Random.Get 



    ;    color    x         y    width    height  
    push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 ; 30 + 4 and 44 + 4 where + 2 is for frame

    call Board.DrawFace

    ; push 0 255
    ; call Random.Get 
 

    mov ax, [CARDCOLOR]
    call Board.renderBoard
    



    ; call Just.Wait 


    ; push 0 255
    ; call Random.Get 

    ; call Board.renderBoard


    call Process.PressedKey




    mov ax, $0C08
    int 21h
    test al, al
    jnz @f
    mov ah, $08
    int 21h

@@:
    movzx ax, [bOldMode]
    int 10h
    mov ah, $05
    mov al, [bOldPage]
    int 10h
    ret
    

        


.EndProc:
    ret

BGCOLOR dw 108

CARDCOLOR dw 68

BORDERCOLOR dw 15

; ------------------- CLEAR SCREEN

Screen.Clear:
    push bp 
    mov bp, sp 

    mov cx, 320*200
    mov di, 0
    mov al, byte[bp + 4]
    rep stosb

    pop bp 
ret 2

; --------------------------------------------- WAIT

Just.Wait:
    push bp 
    mov bp, sp 

    mov cx, 1000
    simpleLoop: 

        mov dx, 30000
        @@: 
            dec dx
        jnz @B

    loop simpleLoop

    pop bp 

ret 

; ------------------------------- ARROWS AND SPACE

Process.PressedKey:
    push bp 
    mov bp, sp 


    check_arrow_key:
    mov ax, $0C08
    int 21h
    test al, al
    jnz @f
    mov ah, $08
    int 21h


    cmp al, 0x48 ; check if up arrow key pressed
    je up_arrow_pressed ; if so, jump to up arrow handler
    cmp al, 0x4B ; check if left arrow key pressed
    je left_arrow_pressed ; if so, jump to left arrow handler
    cmp al, 0x4D ; check if right arrow key pressed
    je right_arrow_pressed ; if so, jump to right arrow handler
    cmp al, 0x50 ; check if down arrow key pressed
    je down_arrow_pressed ; if so, jump to down arrow handler
    cmp al, 0x1b
    je esc_button_pressed
    @@:
    cmp al, 0x20
    je white_space_pressed
    jmp check_arrow_key ; if not arrow key, check next key press

    up_arrow_pressed:
        ; handle up arrow key press

        ; push [BGCOLOR]        
        ; call Screen.Clear

        cmp [YPointer], 50
        jl NotUPPERBorder
        push  [BGCOLOR]   [XPointer] [YPointer]   34      46 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace
        push  [CARDCOLOR]  [XCurrCard] [YCurrCard]   30      42 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace


        sub [YPointer], 50
        sub [YCurrCard], 50

        NotUPPERBorder:

        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace
        mov al, byte[CARDCOLOR]
        call Board.renderBoard  
 
    jmp check_arrow_key

    left_arrow_pressed:
        ; handle left arrow key press

        ; push [BGCOLOR]
        ; call Screen.Clear

        cmp [XPointer], 40
        jl NotLEFTBorder
        push  [BGCOLOR]   [XPointer] [YPointer]   34      46 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace
        push  [CARDCOLOR]  [XCurrCard] [YCurrCard]   30      42 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace


        sub [XPointer], 40
        sub [XCurrCard], 40

        NotLEFTBorder:  
        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace
        mov al, byte[CARDCOLOR]
        call Board.renderBoard

    jmp check_arrow_key

    right_arrow_pressed:
        ; handle right arrow key press

        ; push [BGCOLOR]
        ; call Screen.Clear

        cmp [XPointer], 280
        jg NotRIGHTBorder
        push  [BGCOLOR]   [XPointer] [YPointer]   34      46 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace
        push  [CARDCOLOR]  [XCurrCard] [YCurrCard]   30      42 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace

        add [XPointer], 40
        add [XCurrCard], 40

        NotRIGHTBorder:
        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace
        mov al, byte[CARDCOLOR]
        call Board.renderBoard 

    jmp check_arrow_key

    down_arrow_pressed:
        ; handle down arrow key press

        ; push [BGCOLOR]
        ; call Screen.Clear

        cmp [YPointer], 150
        jg NotBOTTOMBorder

        push  [BGCOLOR]   [XPointer] [YPointer]   34      46 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace
        push  [CARDCOLOR]  [XCurrCard] [YCurrCard]   30      42 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace


        add [YPointer], 50
        add [YCurrCard], 50

        NotBOTTOMBorder:

        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 ; 30 + 4 and 44 + 4 where + 2 is for frame
        call Board.DrawFace
        mov al, byte[CARDCOLOR]
        call Board.renderBoard

    jmp check_arrow_key

    white_space_pressed:



    esc_button_pressed:

        
    ; mov cx, 320*200
    ; mov di, 0   
    ; mov al, byte[BGCOLOR]
    ; rep stosb

    pop bx 
ret  

XPointer dw 43 ; 45 - 2 
YPointer dw 52 ; 54 - 2 where -2 is for frame

XCurrCard dw  45
YCurrCard dw 54
  

; -------------------------------- RANDOM 
Random.Initialize: 
    push bp 
    mov bp, sp 


     mov        ah, $2C
     int        21h
     mov        [Random.wPrevNumber], dx

    pop bp 
ret
      
Random.Get:
     
    push bp 
    mov bp, sp

    mov ax, [bp+4]
    mov [wMax], ax
    mov ax, [bp+6]
    mov [wMin], ax

    mov        ax, [Random.wPrevNumber]
    rol        ax, 7
    adc        ax, 23
    mov        [Random.wPrevNumber], ax

    mov        cx, [wMax]
    sub        cx, [wMin]
    inc        cx
    xor        dx, dx
    div        cx
    add        dx, [wMin]
    xchg       ax, dx
    
    pop bp
ret 4
        
wMax    dw ?
wMin    dw ?
Random.wPrevNumber      dw      ?
; ------------------------ DRAW THE WHOLE BOARD

Board.renderBoard:
    push bp
    mov bp, sp

    mov di, 4
    CreateRow:

    
        mov cx, 5
        CreateElem:

            push di 
            push cx
            ;    color x  y width    height  
            push  ax  cx  di   30      42
            call Board.DrawFace
            pop cx
            pop di 

        add cx, 40
        cmp cx, 325
        jnz CreateElem

    add di, 50
    cmp di, 204
    jnz CreateRow

    

    pop bp
ret

; ------------------------ DRAW A FACE OF A CARD

Board.DrawFace:
    push bp
    mov bp, sp

       
    push $A000
    pop es



    mov ax, [bp + 4]
    mov [HEIGHT], ax
    mov ax, [bp + 6]
    mov [WIDTH], ax
    mov ax, [bp + 8]
    mov [Y], ax
    mov ax, [bp + 10]
    mov [X], ax
    mov ax, [bp + 12]
    mov [COLOR], ax

    mov cx, [HEIGHT]
    mov ax, 2*2*80
    mul [Y]
    mov di, ax
    add di, [X]

    mov al, byte[COLOR]
    rectangleLoop:
        push cx

            mov cx, [WIDTH]   
            
            rep stosb

            sub di, [WIDTH]
            add di, 80*2*2

        pop cx
    loop rectangleLoop

    pop bp
ret 10




X dw 0
Y dw 0 
WIDTH dw 0
HEIGHT dw 0
COLOR dw 0




; -------------------=-----------------
