 
org 100h



; ------------------------------- START

bOldMode db ?
bOldPage db ?

MatchedPairs dw 0
NEEDEDPAIRS dw 16

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
    ; mov ax, 0Fh
    call Board.renderBoard
    

    WHILE_MATCH_LESS_NEEDED:

        ; call Just.Wait 


        ; push 0 255
        ; call Random.Get 

        ; call Board.renderBoard

        call Process.PressedKey
        mov ax, [XCurrCard]
        mov [FirstCardX], ax
        mov ax, [YCurrCard]
        mov [FirstCardY], ax

        call Process.PressedKey
        mov ax, [XCurrCard]
        mov [SecondCardX], ax
        mov ax, [YCurrCard]
        mov [SecondCardY], ax    

    inc [MatchedPairs]
    mov ax, [MatchedPairs]
    cmp ax, word[NEEDEDPAIRS]    
    jne WHILE_MATCH_LESS_NEEDED

    ; поздравить юзера


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

BGCOLOR dw 221

CARDCOLOR dw 2ah

BORDERCOLOR dw 15
CARDWIDTH dw 30
CARDHEIGHT dw 42

FirstCardX dw ?
FirstCardY dw ? 

SecondCardX dw ?
SecondCardY dw ? 



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
        ; get color of current state
        push [XCurrCard] [YCurrCard]
        call Board.GetColor

        cmp [YPointer], 50
        jl UPPERBorder
        ; draw frame
        push  [BGCOLOR]   [XPointer] [YPointer]   34      46 
        call Board.DrawFace
        ; draw card back or face depending on a color of the first pixel 
        push  [CurrColor]  [XCurrCard] [YCurrCard]   [CARDWIDTH]   [CARDHEIGHT]
        call Board.DrawFace
        ; change position of pointers
        sub [YPointer], 50
        sub [YCurrCard], 50

        ; get color of updated state
        push [XCurrCard] [YCurrCard]
        call Board.GetColor

        UPPERBorder:
        ; draw a selecteb by stroke card
        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 
        call Board.DrawFace
        push  [CurrColor]  [XCurrCard] [YCurrCard]  [CARDWIDTH] [CARDHEIGHT] 
        call Board.DrawFace
 
    jmp check_arrow_key

    left_arrow_pressed:
        ; handle left arrow key press

        ; get color of current state
        push [XCurrCard] [YCurrCard]
        call Board.GetColor

        cmp [XPointer], 40
        jl NotLEFTBorder
        ; draw frame
        push  [BGCOLOR]   [XPointer] [YPointer]   34      46 
        call Board.DrawFace
        ; draw card back or face depending on a color of the first pixel 
        push  [CurrColor]  [XCurrCard] [YCurrCard]   [CARDWIDTH] [CARDHEIGHT]  
        call Board.DrawFace
        ; change position of pointers
        sub [XPointer], 40
        sub [XCurrCard], 40
        ; get color of updated state
        push [XCurrCard] [YCurrCard]
        call Board.GetColor

        NotLEFTBorder:  
        ; draw a selecteb by stroke card
        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 
        call Board.DrawFace
        push  [CurrColor]  [XCurrCard] [YCurrCard]  [CARDWIDTH] [CARDHEIGHT] 
        call Board.DrawFace
 
    jmp check_arrow_key

    right_arrow_pressed:
        ; handle right arrow key press

        ; get color of current state
        push [XCurrCard] [YCurrCard]
        call Board.GetColor

        cmp [XPointer], 280
        jg NotRIGHTBorder
        ; draw frame
        push  [BGCOLOR]   [XPointer] [YPointer]   34      46  
        call Board.DrawFace
        ; draw card back or face depending on a color of the first pixel
        push  [CurrColor]  [XCurrCard] [YCurrCard]   [CARDWIDTH] [CARDHEIGHT]  
        call Board.DrawFace
        ; change position of pointers
        add [XPointer], 40
        add [XCurrCard], 40
        ; get color of updated state
        push [XCurrCard] [YCurrCard]
        call Board.GetColor

        NotRIGHTBorder:
        ; draw a selecteb by stroke card
        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 
        call Board.DrawFace
        push  [CurrColor]  [XCurrCard] [YCurrCard]  [CARDWIDTH] [CARDHEIGHT] 
        call Board.DrawFace

    jmp check_arrow_key

    down_arrow_pressed:
        ; handle down arrow key press

        ; get color of current state
        push [XCurrCard] [YCurrCard]
        call Board.GetColor

        cmp [YPointer], 150
        jg NotBOTTOMBorder
        ; draw frame
        push  [BGCOLOR]   [XPointer] [YPointer]   34      46  
        call Board.DrawFace
        ; draw card back or face depending on a color of the first pixel
        push  [CurrColor]  [XCurrCard] [YCurrCard]   [CARDWIDTH] [CARDHEIGHT]  
        call Board.DrawFace

        ; change position of pointers
        add [YPointer], 50
        add [YCurrCard], 50
        ; get color of updated state
        push [XCurrCard] [YCurrCard]
        call Board.GetColor

        NotBOTTOMBorder:
        ; draw a selecteb by stroke card
        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 
        call Board.DrawFace
        push  [CurrColor]  [XCurrCard] [YCurrCard]  [CARDWIDTH] [CARDHEIGHT] 
        call Board.DrawFace

    jmp check_arrow_key

    white_space_pressed:




    esc_button_pressed:

        
    push [XCurrCard] [YCurrCard]
    call Board.XORCard
    ; mov cx, 320*200
    ; mov di, 0   
    ; mov al, byte[BGCOLOR]
    ; rep stosb

    pop bx 

Process.EndProcess:
ret 

XPointer dw 43 ; 45 - 2 
YPointer dw 52 ; 54 - 2 where -2 is for frame

XCurrCard dw  45
YCurrCard dw 54

CurrColor dw ? 
  

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
            push  ax  cx  di [CARDWIDTH]  [CARDHEIGHT]
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

Board.XORCard:
    push bp     
    mov bp, sp 

    mov ax, 80*2*2
    mul word[bp + 4]
    add ax, word[bp + 6]
    mov di, ax 

    push  68h 6fh
    call Random.Get
 
    mov cx, [CARDHEIGHT]
    DrawLines:

        push cx
        mov cx, [CARDWIDTH]
        Lines:

            ; mov word[es:di], ax
            xor word[es:di], ax
            inc di
        loop Lines
        sub di, [CARDWIDTH]
        add di, 320 
        pop cx
    loop DrawLines
    

    pop bp
ret 4

Board.GetColor:
    push bp 
    mov bp, sp

    mov ax, 80*2*2
    mul word[bp + 4]
    add ax, word[bp + 6]
    mov di, ax
    
    ; mov word[es:di], 0Fh
    ; mov ax, byte[es:di]
    ; mov word[bp + 8], ax

    mov ax, word[es:di]
    mov [CurrColor], ax 


    pop bp
ret 4



X dw 0
Y dw 0 
WIDTH dw 0
HEIGHT dw 0
COLOR dw 0




; -----------------------  CARD SECTION 

 