 
org 100h



; ------------------------------- START

bOldMode db ?
bOldPage db ?

MatchedPairs dw 0
NEEDEDPAIRS dw 16

EntryPoint:



    ; call Random.CreateArray


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
        mov ax, [CurrIndex]
        mov [FirstCardIndex], ax

        call Process.PressedKey
        mov ax, [XCurrCard]
        mov [SecondCardX], ax
        mov ax, [YCurrCard]
        mov [SecondCardY], ax    
        mov ax, [CurrIndex]
        mov [SecondCardIndex], ax


        mov ax, [FirstCardIndex]
        mul word[two]
        mov si, ax
        mov ax, [deck + si]

        push ax
        mov ax, [SecondCardIndex]
        mul word[two]
        mov si, ax
        mov cx, [deck + si]
        pop ax

        cmp ax, cx
        
        jne @F

        inc [MatchedPairs]
        jmp WHILE_MATCH_LESS_NEEDED.End

        @@:

        call Just.Wait

        push [CARDCOLOR] [FirstCardX] [FirstCardY] [CARDWIDTH] [CARDHEIGHT]
        call Board.DrawFace
        push [CARDCOLOR] [SecondCardX] [SecondCardY] [CARDWIDTH] [CARDHEIGHT]
        call Board.DrawFace

        

    WHILE_MATCH_LESS_NEEDED.End:
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
EntryPoint.EndProc:
    movzx ax, [bOldMode]
    int 10h
    mov ah, $05
    mov al, [bOldPage]
    int 10h
    ret
    

        



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

FirstCardIndex dw ?
SecondCardIndex dw ?

two dw 2

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

        mov dx, 20000
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

    @@:
    cmp al, 0x20
    je white_space_pressed
    cmp al, 0x1b
    je esc_button_pressed
    jmp check_arrow_key ; if not arrow key, check next key press

    up_arrow_pressed:
 

        cmp [YPointer], 50
        jl UPPERBorder
        ; remove frame
        push   [BGCOLOR]  [XPointer] [YPointer]   34      46  
        call Board.DrawBorder
 
        ; change position of pointers
        sub [YPointer], 50
        sub [YCurrCard], 50
        sub [CurrIndex], 8


        UPPERBorder:
        ; draw a selected frame by stroke card
 
        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46
        call Board.DrawBorder
 
 
    jmp check_arrow_key

    left_arrow_pressed:
        ; handle left arrow key press
 

        cmp [XPointer], 40
        jl NotLEFTBorder
        ; rm frame
        push  [BGCOLOR]   [XPointer] [YPointer]   34      46 
        call Board.DrawBorder
 
        ; change position of pointers
        sub [XPointer], 40
        sub [XCurrCard], 40
        sub [CurrIndex], 1
 

        NotLEFTBorder:  
        ; draw a selecteb by stroke card
        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 
        call Board.DrawBorder
 
 
    jmp check_arrow_key

    right_arrow_pressed:
        ; handle right arrow key press

 

        cmp [XPointer], 280
        jg NotRIGHTBorder
        ; rm frame
        push  [BGCOLOR]   [XPointer] [YPointer]   34      46  
        call Board.DrawBorder
 
        ; change position of pointers
        add [XPointer], 40
        add [XCurrCard], 40
        add [CurrIndex], 1
 
        NotRIGHTBorder:
        ; draw a selecteb by stroke card
        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 
        call Board.DrawBorder

    jmp check_arrow_key

    down_arrow_pressed:
        ; handle down arrow key press
 

        cmp [YPointer], 150
        jg NotBOTTOMBorder
        ; rm frame
        push  [BGCOLOR]   [XPointer] [YPointer]   34      46  
        call Board.DrawBorder
 
        ; change position of pointers
        add [YPointer], 50
        add [YCurrCard], 50
        add [CurrIndex], 8
 
        NotBOTTOMBorder:
        ; draw a selecteb by stroke card
        push  [BORDERCOLOR]   [XPointer] [YPointer]   34      46 
        call Board.DrawBorder

    jmp check_arrow_key

    white_space_pressed:

    ; setting di
    mov ax, 320
    mul word[YCurrCard]
    add ax, word[XCurrCard]
    mov di, ax
    ; clearing ax
    xor ax, ax
    ; getting color from selected card
    mov al, [es:di]
    cmp al, byte[CARDCOLOR]
    ; if card has its face, not change it
    jne Process.EndProcess

        
    push [XCurrCard] [YCurrCard]
    call Board.XORCard
    jmp Process.EndProcess

    esc_button_pressed:
    pop bx
    add sp, 2
    jmp EntryPoint.EndProc


    ; mov cx, 320*200
    ; mov di, 0   
    ; mov al, byte[BGCOLOR]
    ; rep stosb

Process.EndProcess:
    pop bx 


ret 

XPointer dw 43 ; 45 - 2 
YPointer dw 52 ; 54 - 2 where -2 is for frame

XCurrCard dw  45
YCurrCard dw 54

CurrColor dw ? 

CurrIndex dw 9
  

; -------------------------------- RANDOM 
Random.Initialize: 
    push bp 
    mov bp, sp 


     mov        ah, $2C
     int        21h
     mov        [Random.wPrevNumber], dx
     mov        [seed], dx

    pop bp 
ret
      
 
    seed dw 0x123
    f1 dw 0x0001
    f2 dw 0x0002
    

Random.Get:
     
    push bp 
    mov bp, sp

    push bx cx dx 

    mov ax, [bp+4]
    mov [wMax], ax
    mov ax, [bp+6]
    mov [wMin], ax

    mov        ax, [Random.wPrevNumber]
    rol        ax, 7
    adc        ax, 23
    mov        [Random.wPrevNumber], ax

    ; mov ax, [seed]    ; текущий элемент последовательности
    ; mov bx, [f1]      ; первый элемент Фибоначчи
    ; add bx, [f2]      ; второй элемент Фибоначчи
    ; mov [seed], bx    ; сохраняем текущий элемент в seed
    ; mov [f1], bx      ; перезаписываем первый элемент
    ; mov [f2], ax 
    ; mov cx, 6547
    ; div cx
    ; xchg ax, dx


    


    mov        cx, [wMax]
    sub        cx, [wMin]
    inc        cx
    xor        dx, dx
    div        cx
    add        dx, [wMin]
    xchg       ax, dx  

    pop dx cx bx
    
    pop bp
ret 4


 
deck dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
     dw 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16



deckMethods dw Cards.Card1, Cards.Card2, Cards.Card3
            dw Cards.Card4, Cards.Card5, Cards.Card6
            dw Cards.Card7, Cards.Card8, Cards.Card9
            dw Cards.CardA, Cards.CardB, Cards.CardC
            dw Cards.CardD, Cards.CardE, Cards.CardF
            dw Cards.Card10

; deck dw 32 dup 0
deckCounts dw 40 dup 0

Random.CreateArray:
    push bp 
    mov bp, sp

    
    ;   randomize
    call Random.Initialize


    
    CreateDeck:



        push 1 40 
        call Random.Get
        

        mov bx, ax

        genRand1:
        
        push 0 31 
        call Random.Get
        
        
        mov si, ax
        cmp [deck + si], 0
        jnz genRand1

        cmp word[deckCounts + bx], 2
        jge CreateDeck

        mov [deck + si], bx
        inc [deckCounts + bx]



        genRand2:
        
        push 1 32 
        call Random.Get
        
        mov si, ax
        cmp [deck + si], 0
        jnz genRand2

        mov [deck + si], bx
        add [deckCounts + bx], 1

        add word[seed], 1

        mov ax, 0
        mov di, deck
        mov cx, 32
        repnz scasb

    

    
    jz CreateDeck



    pop bp
ret





        
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
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, byte[bp + 12]
    rectangleLoop:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
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

    push  0ah 0eh
    call Random.Get
 
    mov cx, [CARDHEIGHT]
    DrawLines:

        push cx
        mov cx, [CARDWIDTH]
        Lines:

            mov byte[es:di], al
            ; xor word[es:di], ax
            inc di
        loop Lines
        sub di, [CARDWIDTH]
        add di, 320 
        pop cx
    loop DrawLines


    ; mov cx, [CARDHEIGHT]
    ; DrawLines:
    ;     push cx
    ;         mov []
    ;     pop cx
    ; loop DrawLines
    

    pop bp
ret 4

Board.GetColor:

    ; bp + 4 - Y
    ; bp + 6 - X


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

Board.DrawBorder:
    push bp 
    mov bp, sp 

    ; bp + 12 - color
    ; bp + 10 - X
    ; bp + 8 - Y
    ; bp + 6 - width
    ; bp + 4 - height


    
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]
    mov al, byte[bp + 12]


    mov cx, [bp + 6]
    rep stosb 
    sub di, [bp + 6]
    add di, 320
    mov cx, [bp + 6]
    rep stosb 
    sub di, [bp + 6]
    add di, 320

    mov cx, [bp + 4]
    sub cx, 4

    borderLoop:



        push cx

            mov cx, 2 
            
            rep stosb
            add di, [bp + 6]
            sub di, 4

            mov cx, 2
            rep stosb 


            sub di, [bp + 6]
            add di, 80*2*2

        pop cx


    loop borderLoop

   
    mov cx, [bp + 6]
    rep stosb 
    sub di, [bp + 6]
    add di, 320
    mov cx, [bp + 6]
    rep stosb 
    sub di, [bp + 6]

    pop bp 

ret 10
 


; -----------------------  CARD SECTION 

Cards.Card1:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 01h
    rectangleLoop1:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoop1

    pop bp
ret 8

Cards.Card2:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 02h
    rectangleLoop2:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoop2

    pop bp
ret 8

Cards.Card3:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 03h
    rectangleLoop3:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoop3

    pop bp
ret 8

Cards.Card4:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 04h
    rectangleLoop4:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoop4

    pop bp
ret 8

Cards.Card5:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 05h
    rectangleLoop5:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoop5

    pop bp
ret 8

Cards.Card6:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 06h
    rectangleLoop6:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoop6

    pop bp
ret 8

Cards.Card7:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 07h
    rectangleLoop7:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoop7

    pop bp
ret 8

Cards.Card8:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 08h
    rectangleLoop8:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoop8

    pop bp
ret 8

Cards.Card9:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 09h
    rectangleLoop9:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoop9

    pop bp
ret 8

Cards.CardA:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 0ah
    rectangleLoopA:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoopA

    pop bp
ret 8

Cards.CardB:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 0Bh
    rectangleLoopB:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoopB

    pop bp
ret 8

Cards.CardC:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 0Ch
    rectangleLoopC:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoopC

    pop bp
ret 8

Cards.CardD:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 0Dh
    rectangleLoopD:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoopD

    pop bp
ret 8

Cards.CardE:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 0Eh
    rectangleLoopE:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoopE

    pop bp
ret 8

Cards.CardF:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 0Fh
    rectangleLoopF:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoopF

    pop bp
ret 8

Cards.Card10:
    push bp
    mov bp, sp
 
    ; bp + 4 - height
    ; bp + 6 - width
    ; bp + 8 - Y
    ; bp + 10 - X
    ; bp + 12 - color
 
    mov cx, [bp + 4]
    mov ax, 2*2*80
    mul word[bp + 8]
    mov di, ax
    add di, [bp + 10]

    mov al, 6bh
    rectangleLoop10:
        push cx

            mov cx, [bp + 6]   
            
            rep stosb

            sub di, [bp + 6]
            add di, 80*2*2

        pop cx
    loop rectangleLoop10

    pop bp
ret 8