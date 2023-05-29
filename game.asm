 
org 100h



; ------------------------------- START


EntryPoint:











    mov ah, $0F
    int 10h
    mov [bOldMode], al
    mov [bOldPage], bh
    mov ax, $0013
    int 10h


    StartAgain:
    
    ; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    call Random.CreateArray
    

;   randomize
    call Random.Initialize


    ; выбираем рандомный цвет


   
    push $A000
    pop es


    ; no hard coding, ha-ha, of coooourse 
    ; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    call Screen.Start

    ; call Screen.Finish


 

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

        push 3
        call Just.Wait

        push [CARDCOLOR] [FirstCardX] [FirstCardY] [CARDWIDTH] [CARDHEIGHT]
        call Board.DrawFace
        push [CARDCOLOR] [SecondCardX] [SecondCardY] [CARDWIDTH] [CARDHEIGHT]
        call Board.DrawFace

        

    WHILE_MATCH_LESS_NEEDED.End:
    mov ax, [MatchedPairs]
    inc [tries]
    cmp ax, word[NEEDEDPAIRS]    
    jne WHILE_MATCH_LESS_NEEDED

    ; поздравить юзера  
    call Screen.Finish
 

@@:
EntryPoint.EndProc:
    movzx ax, [bOldMode]
    int 10h
    mov ah, $05
    mov al, [bOldPage]
    int 10h
    ret
    

        



ret

bOldMode db ?
bOldPage db ?

MatchedPairs dw 0
NEEDEDPAIRS dw 16

tries dw 0
stringTries dw 0, 10 dup ?
;---------------------
BGCOLOR dw 0x13;221

CARDCOLOR dw 0xa0

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
sixteen dw 16

; ------------------- CLEAR SCR
Screen.Clear:
    push bp 
    mov bp, sp 

    mov cx, 320*200
    mov di, 0
    mov al, byte[bp + 4]
    rep stosb

    pop bp 
ret 2

Buffer dw ?
 
color dw 0x00b1
Screen.Start:
    push bp
    mov bp, sp 
    push es ds

    mov ax, cs
    add ax, 1000h
    mov word[Buffer], ax

    push [Buffer]
    pop es

    push 0xb1
    call Screen.Clear

    mov ah, 09h
    mov dx, newl
    int 21h

    whileKeyNotPressed:

        ; inc [color]

        push 1
        call Just.Wait


        mov ah, 1
        int 16h
        jnz @f

        


        ;sky 

        push 0x7f 0 20 320 20
        call Board.DrawFace 
        push 0x37 0 40 320 20 
        call Board.DrawFace
        push 0x36 0 50 320 10 
        call Board.DrawFace
        push 0x35 0 55 320 5
        call Board.DrawFace
        push 0x33 0 60 320 5
        call Board.DrawFace 
        push 0x44 0 65 320 5 
        call Board.DrawFace
        push 0x43 0 70 320 10
        call Board.DrawFace
        push 0x2b 0 80 320 5
        call Board.DrawFace
        push 0x2b 0 85 320 10
        call Board.DrawFace
        push 0x27 0 95 320 5 
        call Board.DrawFace

         ; sun
        push 0x2a 140 70 40 40
        call Board.DrawFace

        push 0x28 145 65 30 50
        call Board.DrawFace

        push 0x28 135 75 50 30
        call Board.DrawFace


        call Board.MoveClouds

        ; sea
        push 0x68  0 100 320 100
        call Board.DrawFace

        

        push 100 100
        call Board.ShiftWater


        push ds es
        mov ds, word[Buffer]
        push $A000
        pop es
        mov cx, 64000
        xor si, si 
        xor di, di
        rep movsb

        pop es ds 


        mov ah, 09h
        mov dx, string_1
        int 21h
    jmp whileKeyNotPressed
        ; push 0x35  200 100 1 100
        ; call Board.DrawFace


@@:

    mov ah, 0
    int 16h

    pop ds es
    pop bp 
ret 

newl db 10, 13, '$'

string_1 db  13, '         WELCOME TO MEMORY GAME        ', 13,  '$'
string_2 db 10, 13,  '   TIME TO TEST YOU :)' , 10, 13, '$'
string_3 db 10, 13, 10, 13, 10, 13, 10, 13, 10, 13,  'press any key to continue' , 10, 13, '$'


string1 db 10, 13, 10, 13, 10, 13, '      CONGRATS FOR YOU, O WINNER!!!', 13, 10, '$'
string2 db 10, 13, 10, 13, 10, 13, '                IT TOOK   ', 13, 10, '$'
string3 db 10, 13, '                  ',  '$'
string4 db 10, 13, '          MOVES FOR YOU TO WIN', 10, 13, '$'

string5_1 db 10, 13, 10, 13, 10, 13, '    SOMEDAY YOU WILL BECOME A LEGEND', 10, 13, '$'
string5_2 db 10, 13, 10, 13, 10, 13, '       NICE TRY, YOU MADE IT WELL!', 10, 13, '$'
string5_3 db 10, 13, 10, 13, 10, 13, '         YOU COULD DO IT BETTER', 10, 13, '$'
string5_4 db 10, 13, 10, 13, 10, 13, '   HOLY MOLY, IT TOOK SO LONG, MAN...', 10, 13, '$'

; string6 db 10, 13, 10, 13, 10, 13, 10, 13, 10, 13,'  press 1 to play again, or  ', 10, 13, '$'
; string7 db '  any other key to exit.  ', 10, 13, '$'

string8 db  10, 13, 10, 13, 10, 13, 10, 13, 10, 13, '  press any key to exit.  ', 10, 13, '$'
Screen.Finish:
    push bp 
    mov bp, sp 

    push 3
    call Just.Wait
    
    push 0x00
    call Screen.Clear


    ; push [color]
    ; call Screen.Clear

    ; inc [color]



 

    mov ah, 09h
    mov dx, string1
    int 21h
    mov ah, 09h
    mov dx, string2 
    int 21h

    mov ah, 09h
    mov dx, string3
    int 21h

    call Process.transformToString

    mov ah, 09h
    mov dx, newl
    int 21h

    mov ah, 09h
    mov dx, string4
    int 21h

    


    cmp [tries], 16
    jle best
    cmp [tries], 50
    jle nice
    cmp [tries], 80
    jle well 
    mov dx, string5_4
    jmp @f
    
    best:
    mov dx, string5_1
    jmp @f

    well: 
    mov dx, string5_3
    jmp @f 

    nice:
    mov dx, string5_2    
    jmp @f

    @@:
    mov ah, 09h
    int 21h
 

    mov ah, 09h
    mov dx, string8
    int 21h
 

    awaitKeyStroke:

    push 0x25 0 0 320 200
    call Board.DrawBorder
    push 0x23 4 4 312 192
    call Board.DrawBorder
    push 0x22 8 8 304 184
    call Board.DrawBorder
    push 0x21 12 12 296 176
    call Board.DrawBorder
 

    push 1
    call Just.Wait


    push 0x23 0 0 320 200
    call Board.DrawBorder
    push 0x22 4 4 312 192
    call Board.DrawBorder
    push 0x21 8 8 304 184
    call Board.DrawBorder
    push 0x25 12 12 296 176
    call Board.DrawBorder

    push 1
    call Just.Wait


    push 0x22 0 0 320 200
    call Board.DrawBorder
    push 0x21 4 4 312 192
    call Board.DrawBorder
    push 0x25 8 8 304 184
    call Board.DrawBorder
    push 0x23 12 12 296 176
    call Board.DrawBorder


    push 1
    call Just.Wait


    push 0x21 0 0 320 200
    call Board.DrawBorder
    push 0x25 4 4 312 192
    call Board.DrawBorder
    push 0x23 8 8 304 184
    call Board.DrawBorder
    push 0x22 12 12 296 176
    call Board.DrawBorder

    push 1
    call Just.Wait

 

    mov ah, 1
    int 16h
    jnz @f


    jmp awaitKeyStroke
 

@@:
 
    pop bp

ret

decimal2 dw 10

Process.transformToString:

    push bp 
    mov bp, sp 

    xor dx, dx
    mov bx, [decimal2]
    mov ax, [tries]
    ; mul [decimal2
    mov si, stringTries
    

    xor cx, cx
    @@:

        inc cx
        inc si

        div bx
        add dx, '0'
        mov [si], dx
        xor dx, dx
    

        cmp ax, 0
        
    jnz @b

    printLoop: 

        mov ah, 02h
        mov dx, word[si]
        int 21h

        dec si 

    loop printLoop
 

   
    pop bp 

ret



; --------------------------------------------- WAIT



Just.Wait:
    push bp 
    mov bp, sp 
    ; bp + 4 - seconds to wait
    
    mov ax, [bp + 4]
    mul word[nineteen]
    push ax ds si


    push 0
    pop ds

    mov si, 0x046C

    add ax, [si] ;time to finish


    simpleLoop: 


    cmp ax, [si]

    jnb simpleLoop

    pop si ds ax
    pop bp 

ret 2 
nineteen dw 5
timeStart dw 0
timeFinish dw 0



Board.XORCard:
    push bp     
    mov bp, sp 

    mov ax, 80*2*2
    mul word[bp + 4]
    add ax, word[bp + 6]
    mov di, ax  

    mov ax, word[bp + 8]
 
    mov cx, [CARDHEIGHT]
    DrawLines:

        push cx
        mov cx, [CARDWIDTH]
        Lines:

            ; mov byte[es:di], al
            xor word[es:di], ax
            inc di
        loop Lines
        sub di, [CARDWIDTH]
        add di, 320 
        pop cx
    loop DrawLines
 
    

    pop bp
ret 6


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


    ; ; !!!!!!!!!!!!!!!!!!
    jne check_arrow_key

    mov ax, [CurrIndex]
    mul [two]
    mov bx, ax
    mov bx, [deck + bx]

    mov ax, bx
    mul [two]
    xchg ax, bx
    ; mov ax, 18
    ; div [sixteen]

    ; xchg ax, dx

    ; mul [two]
    ; mov bx, ax
    ; mov ax, word[deckMethods + si-2]
    ; mov si, word[deckMethods + si]


    ; mov bx, [deckMethods + bx]

    ; and ax, 0x00FF

    ; and si, 0xFF00
    ; add si, ax
    ; ; dec si
        
    push [XCurrCard] [YCurrCard] [CARDWIDTH] [CARDHEIGHT]
    call word[deckMethods + bx]


    jne Process.EndProcess
        
    ; push [XCurrCard] [YCurrCard]
    ; call Board.XORCard
 




    ; jmp Process.EndProcess

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
    ;  mov        [seed], dx

    pop bp 
ret
      
 
 

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
    inc     [Random.wPrevNumber]

 



    


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


 
; deck dw 3, 0, 1, 6, 8, 9, 7, 12, 2, 13, 11, 10, 15, 4, 5, 14
;      dw 13, 1, 10, 0, 3, 14, 15, 11, 12, 2, 7, 9, 8, 6, 5, 4


; deck dw 5, 14, 3, 9, 8, 12, 8, 13, 1, 5, 10, 0, 3, 4, 11, 1  
;      dw 6, 7, 15, 14, 6, 10, 13, 0, 11, 15, 4, 9, 2, 2, 12, 7


deck dw 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8, 8
     dw 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 14, 15, 15

; skip2 dw 0, 0, 0, 0


deckMethods dw Cards.Card1, Cards.Card2, Cards.Card3
            dw Cards.Card4, Cards.Card5, Cards.Card6
            dw Cards.Card7, Cards.Card8, Cards.Card9
            dw Cards.CardA, Cards.CardB, Cards.CardC
            dw Cards.CardD, Cards.CardE, Cards.CardF
            dw Cards.Card10

; deck dw 32 dup 0
deckCounts dw 40 dup 0

sixfour dw 64

Random.CreateArray:
    push bp 
    mov bp, sp

    
    ;   randomize
    call Random.Initialize

    xor si, si
    createArrayLoop:

        push 0 si 
        call Random.Get

        mul [two]
        div [sixfour]
        xchg ax, dx
        mov bx, ax
        mov cx, [deck + bx]
        xchg [deck + si], cx
        mov [deck + bx], cx



    add si, 2
    cmp si, 64
    jnz createArrayLoop

     
        

 



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
 
Board.ShiftWater: 
    push bp 
    mov bp, sp
    push ax

    mov ax, 320
    mul word[bp + 4]
    mov [FirstToShift], ax
    mov cx, word[bp + 6]
    mov [NumToShift], cx

    mov di, [FirstToShift]
    add di, 318

    push 0x28 [v1x] 102 [vlen] 1
    call Board.DrawFace
    push 0x28 [v2x] 103 [vlen] 1
    call Board.DrawFace
    push 0x28 [v3x] 104 [vlen] 1
    call Board.DrawFace
    push 0x28 [v4x] 105 [vlen] 1
    call Board.DrawFace
    push 0x28 [v6x] 107 [vlen] 1
    call Board.DrawFace
    push 0x28 [v7x] 108 [vlen] 1
    call Board.DrawFace
    push 0x28 [v8x] 109 [vlen] 1
    call Board.DrawFace
    push 0x28 [v9x] 110 [vlen] 1
    call Board.DrawFace
    push 0x28 [v10x] 111 [vlen] 1
    call Board.DrawFace
    push 0x28 [v11x] 112 [vlen] 1
    call Board.DrawFace


    push 0x28 [v14x] 115 [vlen] 1
    call Board.DrawFace
    push 0x28 [v15x] 116 [vlen] 1
    call Board.DrawFace
    push 0x28 [v16x] 117 [vlen] 1
    call Board.DrawFace
    push 0x28 [v17x] 118 [vlen] 1
    call Board.DrawFace

    add [v1x], 6
    add [v2x], 6
    add [v3x], 6
    add [v4x], 6
    add [v6x], 6
    add [v7x], 6
    add [v8x], 6
    add [v9x], 6
    add [v10x], 6
    add [v11x], 6
    add [v14x], 6
    add [v15x], 6
    add [v16x], 6
    add [v17x], 6
 

    push 0x28 [v1x2] 152 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v2x2] 153 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v3x2] 154 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v4x2] 155 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v6x2] 157 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v7x2] 158 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v8x2] 159 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v9x2] 160 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v10x2] 171 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v11x2] 172 [vlen2] 1
    call Board.DrawFace


    push 0x28 [v14x2] 175 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v15x2] 176 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v16x2] 187 [vlen2] 1
    call Board.DrawFace
    push 0x28 [v17x2] 188 [vlen2] 1
    call Board.DrawFace

    add [v1x], 1
    add [v2x], 1
    add [v3x], 1
    add [v4x], 1
    add [v6x], 1
    add [v7x], 1
    add [v8x], 1
    add [v9x], 1
    add [v10x], 1
    add [v11x], 1
    add [v14x], 1
    add [v15x], 1
    add [v16x], 1
    add [v17x], 1

    add [v1x2], 6
    add [v2x2], 6
    add [v3x2], 6
    add [v4x2], 6
    add [v6x2], 6
    add [v7x2], 6
    add [v8x2], 6
    add [v9x2], 6
    add [v10x2], 6
    add [v11x2], 6
    add [v14x2], 6
    add [v15x2], 6
    add [v16x2], 6
    add [v17x2], 6
 




    pop ax
    pop bp
ret 4

vlen dw 80
v1x dw 0 
v2x dw 20 
v3x dw 40 
v4x dw 60 
v6x dw 80
v7x dw 100 
v8x dw 120 
v9x dw 140 

v17x dw 0 
v16x dw 20 
v15x dw 40 
v14x dw 60 
v11x dw 120 
v10x dw 140 

vlen2 dw 120
v1x2 dw 100 
v2x2 dw 120 
v3x2 dw 140 
v4x2 dw 160 
v6x2 dw 180
v7x2 dw 200 
v8x2 dw 220 
v9x2 dw 240 

v17x2 dw 100 
v16x2 dw 120 
v15x2 dw 140 
v14x2 dw 160 
v11x2 dw 220 
v10x2 dw 240 
FirstToShift dw 0 
NumToShift dw 0

randX dw 0 
randY dw 0

Board.MoveClouds:
    push bp 
    mov bp, sp 


    push 0xb3 [cloud1x] [cloud1y] 80 45
    call Board.DrawFace
    push 0xb3 [cloud2x] [cloud2y] 50 30
    call Board.DrawFace
    push 0xb3 [cloud3x] [cloud3y] 160 30
    call Board.DrawFace

    dec [cloud1x]
    dec [cloud2x]
    dec [cloud3x]

    pop bp 
ret
cloud1x dw 3
cloud1y dw 50
cloud2x dw 50
cloud2y dw 30
cloud3x dw 00 
cloud3y dw 50

; -----------------------  CARD SECTION 

Cards.Card1:
    push bp
    mov bp, sp
 
    ; push 13h word[bp + 10] word[bp + 8] word[bp + 6] word[bp + 4] 
    ; call Board.DrawFace

        
        push word[XCurrCard]
        pop word[XDraw]

        push word[YCurrCard]
        pop word[YDraw]

    ; bg sky
    push 65h [XDraw] [YDraw] [CARDWIDTH] 25
    call Board.DrawFace

    ; bg sea
    push [YDraw]
    add [YDraw], 25
    push 3h [XDraw] [YDraw] [CARDWIDTH] 17
    call Board.DrawFace
    pop [YDraw]

    ; wawes
    push [YDraw]
    add [YDraw], 40
    push 64h [XDraw] [YDraw] [CARDWIDTH] 2
    call Board.DrawFace

    dec [YDraw]
    push 64h [XDraw] [YDraw] [CARDWIDTH] 1
    call Board.DrawFace

    push [XDraw]
    add [XDraw], 3
    push 3h [XDraw] [YDraw] 5 1
    call Board.DrawFace

    add [XDraw], 10
    push 3h [XDraw] [YDraw] 1 1
    call Board.DrawFace

    add [XDraw], 6
    push 3h [XDraw] [YDraw] 2 1
    call Board.DrawFace
    pop [XDraw]
    pop [YDraw]

    ; ---------------------
    push [YDraw] [XDraw]

    add [YDraw], 36
    inc [XDraw]
    push 64h [XDraw] [YDraw] 3 1 
    call Board.DrawFace

    dec [YDraw]
    add [XDraw], 3
    push 64h [XDraw] [YDraw] 2 1
    call Board.DrawFace

    inc [YDraw]
    add [XDraw], 2
    push 64h [XDraw] [YDraw] 3 1 
    call Board.DrawFace

    dec [YDraw]
    add [XDraw], 3
    push 64h [XDraw] [YDraw] 2 1
    call Board.DrawFace

    inc [YDraw]
    add [XDraw], 2
    push 64h [XDraw] [YDraw] 3 1 
    call Board.DrawFace

    dec [YDraw]
    add [XDraw], 3
    push 64h [XDraw] [YDraw] 5 1
    call Board.DrawFace

    inc [YDraw]
    add [XDraw], 5
    push 64h [XDraw] [YDraw] 3 1 
    call Board.DrawFace


    inc [YDraw]
    add [XDraw], 3
    push 64h [XDraw] [YDraw] 2 1 
    call Board.DrawFace

    dec [YDraw]
    add [XDraw], 2
    push 64h [XDraw] [YDraw] 2 1
    call Board.DrawFace

    pop [XDraw] [YDraw]
    ; ------------

    push [YDraw] [XDraw]

    add [YDraw], 33
    push 64h [XDraw] [YDraw] 3 1 
    call Board.DrawFace

    dec [YDraw]
    add [XDraw], 3
    push 64h [XDraw] [YDraw] 2 1
    call Board.DrawFace

    inc [YDraw]
    add [XDraw], 2
    push 64h [XDraw] [YDraw] 3 1 
    call Board.DrawFace

    dec [YDraw]
    add [XDraw], 3
    push 64h [XDraw] [YDraw] 2 1
    call Board.DrawFace

    inc [YDraw]
    add [XDraw], 2
    push 64h [XDraw] [YDraw] 3 1 
    call Board.DrawFace

    dec [YDraw]
    add [XDraw], 3
    push 64h [XDraw] [YDraw] 5 1
    call Board.DrawFace

    inc [YDraw]
    add [XDraw], 5
    push 64h [XDraw] [YDraw] 3 1 
    call Board.DrawFace

 

    pop [XDraw] [YDraw]
    ; ------------

        push [YDraw] [XDraw]

    add [YDraw], 29
    push 64h [XDraw] [YDraw] 3 1 
    call Board.DrawFace

    dec [YDraw]
    add [XDraw], 3
    push 64h [XDraw] [YDraw] 2 1
    call Board.DrawFace

    inc [YDraw]
    add [XDraw], 2
    push 64h [XDraw] [YDraw] 3 1 
    call Board.DrawFace

 

 
 

    pop [XDraw] [YDraw]

    ; -------------

    ; beach 
    push [YDraw] [XDraw]
    add [YDraw], 24
    add [XDraw], 6

    push 5Ch [XDraw] [YDraw] 24  3
    call Board.DrawFace

    inc [YDraw]
    sub [XDraw], 2
    push 5Ch [XDraw] [YDraw] 2 2
    call Board.DrawFace

    add [YDraw], 2
    add [XDraw], 3
    push 5Ch [XDraw] [YDraw] 3 1
    call Board.DrawFace

    add [XDraw], 3
    push 5Ch [XDraw] [YDraw] 9 2
    call Board.DrawFace

    add [XDraw], 9
    push 5Ch [XDraw] [YDraw] 11 3
    call Board.DrawFace

    add [YDraw], 2
    add [XDraw], 3
    push 5Ch [XDraw] [YDraw] 4 1 
    call Board.DrawFace 

    inc [YDraw]
    add [XDraw], 2
    push 5Ch [XDraw] [YDraw]  6 1
    call Board.DrawFace

    ; clouds
    pop [XDraw] [YDraw]

    push [XDraw] [YDraw]
    add [YDraw], 9
    push 0fh [XDraw] [YDraw] 4 4 
    call Board.DrawFace

    add [XDraw], 4
    push 0fh [XDraw] [YDraw] 5 3
    call Board.DrawFace

    sub [YDraw], 3
    inc [XDraw]
    push 0fh [XDraw] [YDraw] 9 4
    call Board.DrawFace

    add [XDraw], 4
    sub [YDraw], 3
    push 0fh [XDraw] [YDraw] 11 5
    call Board.DrawFace

    dec [YDraw]
    inc [XDraw]
    push 0fh [XDraw] [YDraw] 19 3
    call Board.DrawFace


    pop [YDraw] [XDraw]

    ; trees
    push [XDraw] [YDraw]
    add [XDraw], 17
    add [YDraw], 20
    push 0x76 [XDraw] [YDraw] 13 5
    call Board.DrawFace

    inc [YDraw]
    sub [XDraw], 3
    push 0x76 [XDraw] [YDraw] 3 4
    call Board.DrawFace

    sub [XDraw], 2
    add [YDraw], 2
    push 0x76 [XDraw] [YDraw] 2 2 
    call Board.DrawFace

    sub [YDraw], 4
    add [XDraw], 5
    push 0x76 [XDraw] [YDraw] 3 1
    call Board.DrawFace

    dec [YDraw]
    add [XDraw], 6
    push 0x76 [XDraw] [YDraw] 6 2 
    call Board.DrawFace
    pop [YDraw] [XDraw]

    ; sun
    add [XDraw], 3
    add [YDraw], 5
    push 2ch [XDraw] [YDraw] 4 4
    call Board.DrawFace


    pop bp
ret 8

XDraw dw ?
YDraw dw ? 

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


    push word[XCurrCard]
    pop word[XDraw]

    push word[YCurrCard]
    pop word[YDraw]
    
    
    push [XDraw] [YDraw]

    ; sky
    push 0x28 [XDraw] [YDraw] 30 21 
    call Board.DrawFace
    
    push 0x29 [XDraw] [YDraw] 30 15
    call Board.DrawFace 

    push 0x2a [XDraw] [YDraw] 30 10
    call Board.DrawFace

    push 0x2b [XDraw] [YDraw] 30 5
    call Board.DrawFace

    add [XDraw], 12
    add [YDraw], 16
    ;sum
    push 0x0F [XDraw] [YDraw] 7 5  
    call Board.DrawFace
    sub [XDraw], 12
    sub [YDraw], 16

    ;sea

    add [YDraw], 21
    push 0x68 [XDraw] [YDraw] 30 21    
    call Board.DrawFace

    add [YDraw], 2
    add [XDraw], 10 
    push 0x29 [XDraw] [YDraw] 20 1
    call Board.DrawFace

    inc [YDraw]
    sub [XDraw], 10
    push 0x2a [XDraw] [YDraw] 15 1
    call Board.DrawFace

    inc [YDraw]
    add [XDraw], 12
    push 0x0F [XDraw] [YDraw] 7 1
    call Board.DrawFace

    inc [YDraw]
    sub [XDraw], 5
    push 0x2a [XDraw] [YDraw] 5 1
    call Board.DrawFace

    add [YDraw], 2
    add [XDraw], 2
    push 0x0F [XDraw] [YDraw] 5 1
    call Board.DrawFace

    add [YDraw], 2
    add [XDraw], 6
    push 0x0F [XDraw] [YDraw] 7 1
    call Board.DrawFace


    add [YDraw], 3
    sub [XDraw], 8
    push 0x0F [XDraw] [YDraw] 3 1
    call Board.DrawFace

    add [YDraw], 3
    add [XDraw], 17
    push 0x0F [XDraw] [YDraw] 2 1
    call Board.DrawFace

    add [YDraw], 3
    sub [XDraw], 8
    push 0x0F [XDraw] [YDraw] 1 1
    call Board.DrawFace
    

    pop [YDraw] [XDraw]

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

 

    push word[XCurrCard]
    pop word[XDraw]

    push word[YCurrCard]
    pop word[YDraw]

    push 0x80 [XDraw] [YDraw] 30 42 
    call Board.DrawFace


    ; green  
    push [XDraw] [YDraw] 
    add [XDraw], 17
    add [YDraw], 24
    push 0x78 [XDraw] [YDraw] 4 8
    call Board.DrawFace

    add [XDraw], 2
    add [YDraw], 5
    push 0x78 [XDraw] [YDraw] 4 8
    call Board.DrawFace

     add [XDraw], 2
    add [YDraw], 5
    push 0x78 [XDraw] [YDraw] 4 8
    call Board.DrawFace

    pop [YDraw] [XDraw]



    ; center
    push [XDraw] [YDraw] 
    add [XDraw], 13
    add [YDraw], 18
    push 0x2b [XDraw] [YDraw] 7 7  
    call Board.DrawFace

    sub [YDraw], 10
    push 0x0F [XDraw] [YDraw] 4 10
    call Board.DrawFace

    add [XDraw], 3
    add [YDraw], 7
    push 0x0F [XDraw] [YDraw] 4 4
    call Board.DrawFace

    add [XDraw], 3
    sub [YDraw], 3
    push 0x0F [XDraw] [YDraw] 4 4
    call Board.DrawFace

    sub [XDraw], 5
    add [YDraw], 6
    sub [XDraw], 3
    sub [YDraw], 3
    push 0x0F [XDraw] [YDraw] 4 4
    call Board.DrawFace

    sub [XDraw], 3
    sub [YDraw], 3
    push 0x0F [XDraw] [YDraw] 4 4
    call Board.DrawFace

    add [XDraw], 7
    add [YDraw], 7
    add [XDraw], 3
    add [YDraw], 3
    push 0x0F [XDraw] [YDraw] 4 4
    call Board.DrawFace

    add [XDraw], 3
    add [YDraw], 3
    push 0x0F [XDraw] [YDraw] 4 4
    call Board.DrawFace

    sub [XDraw], 8
    sub [YDraw], 5

    sub [XDraw], 3
    add [YDraw], 3
    push 0x0F [XDraw] [YDraw] 4 4
    call Board.DrawFace

    sub [XDraw], 3
    add [YDraw], 3
    push 0x0F [XDraw] [YDraw] 4 4
    call Board.DrawFace

    sub [YDraw], 7
    sub [XDraw], 2
    push 0x0F [XDraw] [YDraw] 8 4
    call Board.DrawFace

    add [XDraw], 14
    push 0x0F [XDraw] [YDraw] 8 4
    call Board.DrawFace

    add [YDraw], 5
    sub [XDraw], 5
      push 0x0F [XDraw] [YDraw] 4 8
    call Board.DrawFace  



    pop [YDraw] [XDraw]

        add [XDraw], 17
    add [YDraw], 24
    push 0x78 [XDraw] [YDraw] 4 8
    call Board.DrawFace
 

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

    push word[XCurrCard]
    pop word[XDraw]

    push word[YCurrCard]
    pop word[YDraw]
 
    push [XDraw] [YDraw]
      push 0x4e [XDraw] [YDraw] 30 42
    call Board.DrawFace


    add [YDraw],30
    push 0x75 [XDraw] [YDraw] 30 12
    call Board.DrawFace
    sub [YDraw], 30 

   add [XDraw], 13
    add [YDraw], 21
    push 0xd0 [XDraw] [YDraw] 3 20
    call Board.DrawFace

  

        pop  [YDraw] [XDraw]

    push [XDraw] [YDraw]

 
    add [XDraw], 15
    add [YDraw], 8
    push 0xbf [XDraw] [YDraw] 14 14
    call Board.DrawFace

    sub [XDraw], 6
    add [YDraw], 3
     push 0xbf [XDraw] [YDraw] 14 14
    call Board.DrawFace 

    sub [XDraw], 6
    add [YDraw], 3
     push 0xbf [XDraw] [YDraw] 14 14
    call Board.DrawFace  
    pop  [YDraw] [XDraw]

    push [XDraw] [YDraw]
    add [XDraw], 10
    add [YDraw], 16
    push 0xbf [XDraw] [YDraw] 14 14
    call Board.DrawFace

    sub [XDraw], 6
    add [YDraw], 3
     push 0xbf [XDraw] [YDraw] 14 14
    call Board.DrawFace 

    pop  [YDraw] [XDraw]

    push [XDraw] [YDraw]
    add [XDraw], 4
    add [YDraw], 8
    push 0xbf [XDraw] [YDraw] 14 14
    call Board.DrawFace

    add [XDraw], 6
    sub [YDraw], 3
       push 0xbf [XDraw] [YDraw] 14 14
    call Board.DrawFace 

 
    pop [YDraw] [XDraw]

    ;flowers
   
    push [XDraw] [YDraw] 
    add [YDraw], 10
    add [XDraw], 15
    push 0x0f [XDraw] [YDraw] 2 2
    call Board.DrawFace 

    add [XDraw], 10
    add [YDraw], 3    
    push 0x0f [XDraw] [YDraw] 2 2
    call Board.DrawFace

    sub [XDraw], 18
    add [YDraw], 3
    push 0x0f [XDraw] [YDraw] 2 2
    call Board.DrawFace
    
    add [XDraw], 8
    inc [YDraw]
    push 0x0f [XDraw] [YDraw] 2 2
    call Board.DrawFace   

    add [XDraw], 4
    inc [YDraw]
    push 0x0f [XDraw] [YDraw] 2 2
    call Board.DrawFace

    sub [XDraw], 15
    add [YDraw], 3
    push 0x0f [XDraw] [YDraw] 2 2
    call Board.DrawFace

    add [XDraw], 10
    add [YDraw], 3
    push 0x0f [XDraw] [YDraw] 2 2
    call Board.DrawFace

    sub [XDraw], 7
    add [YDraw], 3
    push 0x0f [XDraw] [YDraw] 2 2
    call Board.DrawFace
    pop [YDraw] [XDraw]




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

 
    push word[XCurrCard]
    pop word[XDraw]

    push word[YCurrCard]
    pop word[YDraw]

    ; bg
    push [XDraw] [YDraw] 
    
        ;sky
    push 0x36 [XDraw] [YDraw] 30 18
    call Board.DrawFace

        ;beach
    add [YDraw], 18
    push 0x43 [XDraw] [YDraw] 30 24
    call Board.DrawFace

        ;sea

    push 0x4f [XDraw] [YDraw] 30 4
    call Board.DrawFace

    add [YDraw], 4
    push 0x4f [XDraw] [YDraw]  23 1
    call Board.DrawFace

    inc [YDraw]
    push 0x4f [XDraw] [YDraw] 9 1 
    call Board.DrawFace

    inc [YDraw]
    push 0x4f [XDraw] [YDraw] 6 1 
    call Board.DrawFace

    inc [YDraw]
    push 0x4f [XDraw] [YDraw] 5 2 
    call Board.DrawFace

    inc [YDraw]
    push 0x4f [XDraw] [YDraw] 2 1 
    call Board.DrawFace
 
    pop [YDraw] [XDraw]

        ;crab
    push [XDraw] [YDraw]
      add [XDraw], 11
      add [YDraw], 28
      push 0x27 [XDraw] [YDraw] 11 6
      call Board.DrawFace
    pop [YDraw] [XDraw]

    push [XDraw] [YDraw]
      add [XDraw], 10
      add [YDraw], 29
      push 0x27 [XDraw] [YDraw] 13 6
      call Board.DrawFace
    pop [YDraw] [XDraw]

    push [XDraw] [YDraw]
       add [XDraw], 10
      add [YDraw], 35
      push 0x27 [XDraw] [YDraw] 2 3
      call Board.DrawFace

      add [XDraw], 3
      push 0x27 [XDraw] [YDraw] 2 3
      call Board.DrawFace

      add [XDraw], 6
      push 0x27 [XDraw] [YDraw] 2 3
      call Board.DrawFace
        
      add [XDraw], 3
      push 0x27 [XDraw] [YDraw] 2 3
      call Board.DrawFace
    pop [YDraw] [XDraw]

    push [XDraw] [YDraw]
      add [XDraw], 14
      add [YDraw], 25
      push 0x27 [XDraw] [YDraw] 2 3
      call Board.DrawFace
      add [XDraw], 4
      push 0x27 [XDraw] [YDraw] 2 3
      call Board.DrawFace


    pop [YDraw] [XDraw]

    push [XDraw] [YDraw]
      add [XDraw], 14
      add [YDraw], 23
      push 0x0f [XDraw] [YDraw] 2 3
      call Board.DrawFace
      add [XDraw], 4
      push 0x0f [XDraw] [YDraw] 2 3
      call Board.DrawFace

    pop [YDraw] [XDraw]

        push [XDraw] [YDraw]
      add [XDraw], 14
      add [YDraw], 23
      push 0x00 [XDraw] [YDraw] 2 2
      call Board.DrawFace
      add [XDraw], 4
      push 0x00 [XDraw] [YDraw] 2 2
      call Board.DrawFace


    pop [YDraw] [XDraw]


    push [XDraw] [YDraw]
      add [XDraw], 4
      add [YDraw], 24
      push 0x27 [XDraw] [YDraw] 2 3
      call Board.DrawFace

      add [YDraw], 3
      inc [XDraw]
      push 0x27 [XDraw] [YDraw] 2 1
      call Board.DrawFace

      inc [YDraw]
      inc [XDraw]
      push 0x27 [XDraw] [YDraw] 3 1
      call Board.DrawFace

      inc [YDraw]
      inc [XDraw]
      push 0x27 [XDraw] [YDraw] 3 1
      call Board.DrawFace

      inc [YDraw]
      add [XDraw], 3
      push 0x27 [XDraw] [YDraw] 2 2
      call Board.DrawFace

         


    pop [YDraw] [XDraw]

        push [XDraw] [YDraw]
      add [XDraw], 27
      add [YDraw], 24
      push 0x27 [XDraw] [YDraw] 2 3
      call Board.DrawFace

      add [YDraw], 3
      dec [XDraw]
      push 0x27 [XDraw] [YDraw] 2 1
      call Board.DrawFace

    ;   inc [YDraw] 
      dec [XDraw]
      push 0x27 [XDraw] [YDraw] 3 1
      call Board.DrawFace

      add  [YDraw],1
      dec [XDraw]
      push 0x27 [XDraw] [YDraw] 3 1
      call Board.DrawFace

      inc [YDraw]
      dec [XDraw]
      push 0x27 [XDraw] [YDraw] 2 2
      call Board.DrawFace

         


    pop [YDraw] [XDraw]

  

    push [XDraw] [YDraw]
      add [XDraw], 7
      add [YDraw], 25
      push 0x27 [XDraw] [YDraw] 1 5
      call Board.DrawFace

    add [XDraw], 17 
      push 0x27 [XDraw] [YDraw] 1 5
      call Board.DrawFace
         


    pop [YDraw] [XDraw]

 
    push [XDraw] [YDraw]
      add [XDraw], 19
      add [YDraw], 6
      push 0x2b [XDraw] [YDraw] 5 5
      call Board.DrawFace
 

    pop [YDraw] [XDraw]

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

    push word[XCurrCard]
    pop word[XDraw]

    push word[YCurrCard]
    pop word[YDraw]

    ; bg
    push [XDraw] [YDraw] 
    
        push 0x65 [XDraw] [YDraw] 30 19
        call Board.DrawFace

        add [YDraw], 19
        push 0x36 [XDraw] [YDraw] 30 23
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]
    
    push [XDraw] [YDraw] 
        add [XDraw], 12
        add [YDraw], 24

    
        push 0x43 [XDraw] [YDraw] 18 8
        call Board.DrawFace

        add [XDraw], 10
        dec [YDraw]
        push 0x43 [XDraw] [YDraw] 7 1
        call Board.DrawFace  

        sub [XDraw], 3
        add [YDraw], 9
        push 0x43 [XDraw] [YDraw] 8 1
        call Board.DrawFace 



    pop [YDraw] [XDraw]

        push [XDraw] [YDraw] 
        add [XDraw], 10
        add [YDraw], 26

    
        push 0x43 [XDraw] [YDraw] 2 6
        call Board.DrawFace
 
    pop [YDraw] [XDraw]
 

    push [XDraw] [YDraw] 
        add [XDraw], 16
        add [YDraw], 17

    
        push 0x70 [XDraw] [YDraw] 1 11
        call Board.DrawFace

        inc [XDraw]
        push 0x06 [XDraw] [YDraw] 2 11
        call Board.DrawFace      
 
    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
        add [XDraw],  7
        add [YDraw], 15

    
        push 0x02 [XDraw] [YDraw] 1 2
        call Board.DrawFace

        inc [XDraw]
        dec [YDraw]
        push 0x02 [XDraw] [YDraw] 1 2
        call Board.DrawFace

        inc [XDraw]
        dec [YDraw]
        push 0x02 [XDraw] [YDraw] 5 3
        call Board.DrawFace       

        inc [YDraw]
        add [XDraw], 5
        push 0x02 [XDraw] [YDraw] 10 3
        call Board.DrawFace 

        inc [XDraw]
        sub [YDraw], 2
        push 0x02 [XDraw] [YDraw] 4 2
        call Board.DrawFace  

 
    pop [YDraw] [XDraw]
    

        push [XDraw] [YDraw] 
        add [XDraw],  11
        add [YDraw], 19

    
        push 0x02 [XDraw] [YDraw] 3 3
        call Board.DrawFace

        inc [XDraw]
        dec [YDraw]
        push 0x02 [XDraw] [YDraw] 3 2
        call Board.DrawFace

        inc [XDraw]
        dec [YDraw]
        push 0x02 [XDraw] [YDraw] 4 2
        call Board.DrawFace  

        add [XDraw], 5 
        push 0x02 [XDraw] [YDraw] 4 2
        call Board.DrawFace     

        inc [YDraw]
        inc [XDraw]
        push 0x02 [XDraw] [YDraw] 4 3
        call Board.DrawFace 

        add [YDraw], 3
        inc [XDraw]
        push 0x02 [XDraw] [YDraw] 3 1
        call Board.DrawFace  

 
    pop [YDraw] [XDraw]
 
    
    push [XDraw] [YDraw] 
        add [XDraw],  22
        add [YDraw], 3

    
        push 0x2c [XDraw] [YDraw] 4 4
        call Board.DrawFace

       

 
    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
        add [XDraw],  22
        add [YDraw], 3

    
        push 0x2c [XDraw] [YDraw] 4 4
        call Board.DrawFace

       

 
    pop [YDraw] [XDraw]

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

    push word[XCurrCard]
    pop word[XDraw]

    push word[YCurrCard]
    pop word[YDraw]

    ; bg
    push [XDraw] [YDraw] 
 
        push 0x6a [XDraw] [YDraw] 30 42
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]
    push [XDraw] [YDraw] 
    
        add [XDraw],  28
        add [YDraw], 3
 
        push 0x1d [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
    
        add [XDraw],  23
        add [YDraw], 9
 
        push 0x1d [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]
    push [XDraw] [YDraw] 
    
        add [XDraw],  18
        add [YDraw], 16
 
        push 0x1d [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
    
        add [XDraw],  8
        add [YDraw], 23
 
        push 0x1d [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
    
        add [XDraw],  26
        add [YDraw], 23
 
        push 0x1d [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
    
        add [XDraw],  6
        add [YDraw], 33
 
        push 0x1d [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
    
        add [XDraw],  18
        add [YDraw], 34
 
        push 0x1d [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
    
        add [XDraw],  14
        add [YDraw], 40
 
        push 0x1d [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]
    push [XDraw] [YDraw] 
    
        add [XDraw],  29
        add [YDraw], 38
 
        push 0x1d [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]
    
    push [XDraw] [YDraw] 
    
        add [XDraw],  3
        add [YDraw], 17
 
        push 0x2b [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]
        
    push [XDraw] [YDraw] 
    
        add [XDraw],  27
        add [YDraw], 16
 
        push 0x2b [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]
        
    push [XDraw] [YDraw] 
    
        add [XDraw],  17
        add [YDraw], 24
 
        push 0x2b [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]
        
    push [XDraw] [YDraw] 
    
        add [XDraw],  4
        add [YDraw], 39
 
        push 0x2b [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]
        
    push [XDraw] [YDraw] 
    
        add [XDraw],  23
        add [YDraw], 38
 
        push 0x2b [XDraw] [YDraw] 2 2
        call Board.DrawFace 
        

    pop [YDraw] [XDraw]

        
    push [XDraw] [YDraw] 
    
        add [XDraw],  5
        add [YDraw], 7

        push 0x0f [XDraw] [YDraw] 5 4
        call Board.DrawFace 

        inc [XDraw]
        sub [YDraw], 2
        push 0x0f [XDraw] [YDraw] 5 2
        call Board.DrawFace 

        inc [XDraw]
        dec [YDraw]
        push 0x0f [XDraw] [YDraw] 7 2
        call Board.DrawFace 

        add [XDraw], 2
        dec [YDraw]
        push 0x0f [XDraw] [YDraw] 3 2
        call Board.DrawFace 

        add [XDraw], 4
        add [YDraw], 3
        push 0x0f [XDraw] [YDraw] 2 2
        call Board.DrawFace 
    pop [YDraw] [XDraw]
    push [XDraw] [YDraw] 
    
        add [XDraw], 6
        add [YDraw], 10

        push 0x0f [XDraw] [YDraw] 5 2
        call Board.DrawFace 

        inc [XDraw]
        add [YDraw], 2
        push 0x0f [XDraw] [YDraw] 7 2
        call Board.DrawFace 
 
        add [XDraw], 2
        inc [YDraw]
        push 0x0f [XDraw] [YDraw] 3 2
        call Board.DrawFace 

        add [XDraw], 4
        sub [YDraw], 3
        push 0x0f [XDraw] [YDraw] 2 2
        call Board.DrawFace 
    pop [YDraw] [XDraw]

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

    push word[XCurrCard]
    pop word[XDraw]

    push word[YCurrCard]
    pop word[YDraw]

    ; bg
    push [XDraw] [YDraw] 
 
        push 0x66 [XDraw] [YDraw] 30 42
        call Board.DrawFace 

        add [YDraw], 20
        push 0x76 [XDraw] [YDraw] 30 22
        call Board.DrawFace        
        

    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
        
        add [YDraw], 16
 
        push 0xbf [XDraw] [YDraw] 11 9
        call Board.DrawFace 
      
        

    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
        add [XDraw], 5
        add [YDraw], 14
 
        push 0xbf [XDraw] [YDraw] 7 11
        call Board.DrawFace 
      
        

    pop [YDraw] [XDraw]
    push [XDraw] [YDraw] 
        add [XDraw], 12
        add [YDraw], 11
 
        push 0xbf [XDraw] [YDraw] 8 16
        call Board.DrawFace 
      
        

    pop [YDraw] [XDraw]
    push [XDraw] [YDraw] 
        add [XDraw], 20
        add [YDraw], 12
 
        push 0xbf [XDraw] [YDraw] 9 5
        call Board.DrawFace 
      
        

    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
        add [XDraw], 25
        add [YDraw], 11
 
        push 0xbf [XDraw] [YDraw] 5 5
        call Board.DrawFace 
      
        

    pop [YDraw] [XDraw]
    push [XDraw] [YDraw] 
        add [XDraw], 13
        add [YDraw], 6
 
        push 0x04 [XDraw] [YDraw] 6 23
        call Board.DrawFace 
        inc [XDraw]
        push 0x04 [XDraw] [YDraw] 4 24
        call Board.DrawFace    
      
        

    pop [YDraw] [XDraw]
    push [XDraw] [YDraw] 
        add [XDraw], 19
        add [YDraw], 14
 
        push 0x70 [XDraw] [YDraw] 2 15
        call Board.DrawFace 
       
    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
        add [XDraw], 21
        add [YDraw], 16
 
        push 0x04 [XDraw] [YDraw] 9 13
        call Board.DrawFace 
       
    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
        add [XDraw], 23
        add [YDraw], 14
 
        push 0x04 [XDraw] [YDraw] 2 2
        call Board.DrawFace 

        add [XDraw], 4
        push 0x04 [XDraw] [YDraw] 2 2
        call Board.DrawFace        
       
    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
        add [XDraw], 14
        add [YDraw], 6
 
        push 0x66 [XDraw] [YDraw] 1 3 
        call Board.DrawFace 
        push 0x66 [XDraw] [YDraw]  3 1 
        call Board.DrawFace 

        add [XDraw], 3
        push 0x66 [XDraw] [YDraw] 1 3
        call Board.DrawFace        
       
    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
        add [XDraw], 15
        add [YDraw], 12
 
        push 0x14 [XDraw] [YDraw] 2 3 
        call Board.DrawFace 
    

        add [YDraw], 5
        push 0x14 [XDraw] [YDraw] 2 3
        call Board.DrawFace  
                add [YDraw], 5
        push 0x14 [XDraw] [YDraw] 2 3
        call Board.DrawFace        
       
    pop [YDraw] [XDraw]

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

    push word[XCurrCard]
    pop word[XDraw]

    push word[YCurrCard]
    pop word[YDraw]

    ; bg
    push [XDraw] [YDraw] 
 
        push 0x37 [XDraw] [YDraw] 30 42
        call Board.DrawFace 

        add [YDraw], 20
        push 0x0F [XDraw] [YDraw] 30 4 
        call Board.DrawFace        

        add [YDraw], 2
        push 0x66 [XDraw] [YDraw] 30 8 
        call Board.DrawFace   

        add [YDraw], 2
        push 0x4e [XDraw] [YDraw] 30 4
        call Board.DrawFace 

        add [YDraw], 2
        push 0x4b [XDraw] [YDraw] 30 16 
        call Board.DrawFace        

        

    pop [YDraw] [XDraw]

    push [XDraw] [YDraw] 
 
        add [XDraw], 7
        add [YDraw], 7

        push 0x00 [XDraw] [YDraw] 2 1 
        call Board.DrawFace  
        
        inc [YDraw]
        inc [XDraw]
        push 0x00 [XDraw] [YDraw] 4 1 
        call Board.DrawFace       

        inc [YDraw]
        inc [XDraw]
        push 0x00 [XDraw] [YDraw] 2 1 
        call Board.DrawFace  

        sub [YDraw], 2
        add [XDraw], 2
        push 0x00 [XDraw] [YDraw] 3 1 
        call Board.DrawFace  

        dec [YDraw]
        add [XDraw], 2
        push 0x00 [XDraw] [YDraw] 1 1 
        call Board.DrawFace  



        
        

    pop [YDraw] [XDraw]


    push [XDraw] [YDraw] 
 
        add [XDraw], 18
        add [YDraw], 11

        push 0x00 [XDraw] [YDraw] 2 1 
        call Board.DrawFace  
        
        inc [YDraw]
        inc [XDraw]
        push 0x00 [XDraw] [YDraw] 4 1 
        call Board.DrawFace       

        inc [YDraw]
        inc [XDraw]
        push 0x00 [XDraw] [YDraw] 2 1 
        call Board.DrawFace  

        sub [YDraw], 2
        add [XDraw], 2
        push 0x00 [XDraw] [YDraw] 3 1 
        call Board.DrawFace  

        dec [YDraw]
        add [XDraw], 2
        push 0x00 [XDraw] [YDraw] 2 1 
        call Board.DrawFace  

 
    pop [YDraw] [XDraw]
    
    push [XDraw] [YDraw] 
 
        add [XDraw], 11
        add [YDraw], 19

        push 0x00 [XDraw] [YDraw] 1 1 
        call Board.DrawFace  
        
        inc [YDraw]
        inc [XDraw]
        push 0x00 [XDraw] [YDraw] 4 1 
        call Board.DrawFace       

        inc [YDraw]
        inc [XDraw]
        push 0x00 [XDraw] [YDraw] 2 1 
        call Board.DrawFace  

        sub [YDraw], 2
        add [XDraw], 2
        push 0x00 [XDraw] [YDraw] 3 1 
        call Board.DrawFace  

        dec [YDraw]
        add [XDraw], 2
        push 0x00 [XDraw] [YDraw] 2 1 
        call Board.DrawFace  

 
    pop [YDraw] [XDraw]



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
    
    push [XCurrCard] [YCurrCard] [CARDWIDTH] [CARDHEIGHT] 
    Call Cards.Card9 
    push 10 [XCurrCard] [YCurrCard] 
    call Board.XORCard


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

    push [XCurrCard] [YCurrCard] [CARDWIDTH] [CARDHEIGHT] 
    Call Cards.Card2
    push 200 [XCurrCard] [YCurrCard] 
    call Board.XORCard
  
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
     push [XCurrCard] [YCurrCard] [CARDWIDTH] [CARDHEIGHT] 
    Call Cards.Card3
    push 50 [XCurrCard] [YCurrCard] 
    call Board.XORCard
   

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
      push [XCurrCard] [YCurrCard] [CARDWIDTH] [CARDHEIGHT] 
    Call Cards.Card7
    push 100 [XCurrCard] [YCurrCard] 
    call Board.XORCard
 

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
 
    push [XCurrCard] [YCurrCard] [CARDWIDTH] [CARDHEIGHT] 
    Call Cards.Card4
    push 50 [XCurrCard] [YCurrCard] 
    call Board.XORCard
 

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
  
    push [XCurrCard] [YCurrCard] [CARDWIDTH] [CARDHEIGHT] 
    Call Cards.Card8
    push 100 [XCurrCard] [YCurrCard] 
    call Board.XORCard
 
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
 
  
    push [XCurrCard] [YCurrCard] [CARDWIDTH] [CARDHEIGHT] 
    Call Cards.Card6
    push 10 [XCurrCard] [YCurrCard] 
    call Board.XORCard

    pop bp
ret 8