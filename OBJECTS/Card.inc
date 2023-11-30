    CardVertCount     dd       108

    card0      equ     -1.3, 0.0, 0.0
    card1      equ     -1.3, 0.0, 0.15
    card2      equ     -1.5, 0.2, 0.15
    card3      equ     -1.5, 0.2, 0.0
    card4      equ     1.5, 0.2, 0.0
    card5      equ     1.5, 0.2, 0.15
    card6      equ     1.3, 0.0, 0.15
    card7      equ     1.3, 0.0, 0.0
    card8      equ     1.3, 4.2, 0.0
    card9      equ     1.3, 4.2, 0.15
    card10     equ     1.5, 4.0, 0.15
    card11     equ     1.5, 4.0, 0.0
    card12     equ     -1.5, 4.0, 0.0
    card13     equ     -1.5, 4.0, 0.15
    card14     equ     -1.3, 4.2, 0.15
    card15     equ     -1.3, 4.2, 0.0
    card16     equ     -1.3, 0.2, 0.15
    card17     equ     1.3, 0.2, 0.15
    card18     equ     1.3, 4.0, 0.15
    card19     equ     -1.3, 4.0, 0.15
    card20     equ     -1.3, 0.2, 0.0
    card21     equ     1.3, 0.2, 0.0
    card22     equ     1.3, 4.0, 0.0
    card23     equ     -1.3, 4.0, 0.0

    cardTex1    equ     0.825, 0.0
    cardTex2    equ     0.875, 0.05
    cardTex5    equ     0.125, 0.05
    cardTex6    equ     0.175, 0.0
    cardTex9    equ     0.175, 1.0
    cardTex10   equ     0.125, 0.95
    cardTex13   equ     0.875, 0.95
    cardTex14   equ     0.825, 1.0
    cardTex16   equ     0.825, 0.05
    cardTex17   equ     0.175, 0.05
    cardTex18   equ     0.175, 0.95
    cardTex19   equ     0.825, 0.95   



cardVertices    dd      card0, card1, card2,\ ; chamfers
                        card0, card2, card3,\
                        card4, card5, card6,\
                        card4, card6, card7,\
                        card8, card9, card10,\
                        card8, card10,card11,\
                        card12, card13, card14,\ 
                        card12, card14, card15,\  
                        card0, card1, card7,\ ; side north 
                        card1, card6, card7,\
                        card4, card5, card11,\ ; side east
                        card5, card10, card11,\ 
                        card8, card9, card15,\ ; side south
                        card9, card14, card15,\  
                        card2, card3, card13,\ ; side west
                        card3, card12, card13
                        
cardFace        dd      card2, card5, card13,\ ; big north up 
                        card5, card10, card13,\    
                        card1, card2, card16,\ ; above chamfers
                        card5, card6, card17,\
                        card9, card10, card18,\
                        card13,card14,card19,\
                        card1, card6, card16,\ ; prolonged north up 
                        card6, card16, card17,\
                        card9, card14, card18,\ ; prolonged south up 
                        card14, card18, card19

cardBack        dd      card3, card4, card12,\  ; big north down
                        card4, card11, card12,\
                        card0, card3, card20,\ ; below chamfers
                        card4, card7, card21,\
                        card8, card11,card22,\ 
                        card12, card15, card23,\
                        card0, card7, card20,\  ; prolonged north down
                        card7, card20, card21,\
                        card8, card15, card22,\ ; prolonged south down
                        card15, card22, card23 


   
; back, but applied to face (baaaad naming) ????
cardTextures    dd      cardTex2, cardTex5, cardTex13,\ ; big north up
                        cardTex5, cardTex10, cardTex13,\
                        cardTex1, cardTex2, cardTex16,\ ; above chamfers
                        cardTex5, cardTex6, cardTex17,\
                        cardTex9, cardTex10, cardTex18,\
                        cardTex13,cardTex14,cardTex19,\
                        cardTex1, cardTex6, cardTex16,\ ; prolonged north up 
                        cardTex6, cardTex16, cardTex17,\
                        cardTex9, cardTex14, cardTex18,\ ; prolonged south up 
                        cardTex14, cardTex18, cardTex19



  
    cardColors      dd      18       dup     (0.0, 0.0, 1.0),\
                            18       dup     (0.0, 0.0, 1.0),\
                            18       dup     (0.0, 0.0, 1.0)
        

texture11          dd    0
                               
    cardWidth       dd      3.0
    cardHeight      dd      4.4
    
    marginX         dd      2.0
    marginY         dd      2.0
cardBrdrHandler         dd      0

cardStateMatrix         db  0, 0, 0, 0, 0, 0, 0, 0,\
                            0, 0, 0, 0, 0, 0, 0, 0,\
                            0, 0, 0, 0, 0, 0, 0, 0,\
                            0, 0, 0, 0, 0, 0, 0, 0

cardAngleMatrix         dd  0, 0, 0, 0, 0, 0, 0, 0,\
                            0, 0, 0, 0, 0, 0, 0, 0,\
                            0, 0, 0, 0, 0, 0, 0, 0,\
                            0, 0, 0, 0, 0, 0, 0, 0


cardPicMatrix           dd  0, 0, 1, 1, 2, 2, 3, 3,\
                            4, 4, 5, 5, 6, 6, 7, 7,\
                            8, 8, 9, 9, 10, 10, 11, 11,\
                            12, 12, 13, 13, 14, 14, 15, 15



timeToWait          dd      700

cardRotAngStep      dd      3.0
cardRotStopAng      dd      180.1
cardsSelected       dd      -1, -1
cardMinusRotStopAng  dd     360.1

numOfCurrOpened       dd      0 
numOfTriedPairs       dd      0

numOfGuessedPairs       dd      0           ; up to 16

        card1X1       dd      ?
        card1Y1       dd      ?
        card1X2       dd      ?
        card1Y2       dd      ?

        card2X1       dd      ?
        card2Y1       dd      ?
        card2X2       dd      ?
        card2Y2       dd      ?

        card3X1       dd      ?
        card3Y1       dd      ?
        card3X2       dd      ?
        card3Y2       dd      ?

        card4X1       dd      ?
        card4Y1       dd      ?
        card4X2       dd      ?
        card4Y2       dd      ?

        card5X1       dd      ?
        card5Y1       dd      ?
        card5X2       dd      ?
        card5Y2       dd      ?

        card6X1       dd      ?
        card6Y1       dd      ?
        card6X2       dd      ?
        card6Y2       dd      ?

        card7X1       dd      ?
        card7Y1       dd      ?
        card7X2       dd      ?
        card7Y2       dd      ?

        card8X1       dd      ?
        card8Y1       dd      ?
        card8X2       dd      ?
        card8Y2       dd      ?

        card9X1       dd      ?
        card9Y1       dd      ?
        card9X2       dd      ?
        card9Y2       dd      ?

        card10X1       dd      ?
        card10Y1       dd      ?
        card10X2       dd      ?
        card10Y2       dd      ?

        card11X1       dd      ?
        card11Y1       dd      ?
        card11X2       dd      ?
        card11Y2       dd      ?

        card12X1       dd      ?
        card12Y1       dd      ?
        card12X2       dd      ?
        card12Y2       dd      ?

        card13X1       dd      ?
        card13Y1       dd      ?
        card13X2       dd      ?
        card13Y2       dd      ?

        card14X1       dd      ?
        card14Y1       dd      ?
        card14X2       dd      ?
        card14Y2       dd      ?

        card15X1       dd      ?
        card15Y1       dd      ?
        card15X2       dd      ?
        card15Y2       dd      ?

        card16X1       dd      ?
        card16Y1       dd      ?
        card16X2       dd      ?
        card16Y2       dd      ?

        card17X1       dd      ?
        card17Y1       dd      ?
        card17X2       dd      ?
        card17Y2       dd      ?

        card18X1       dd      ?
        card18Y1       dd      ?
        card18X2       dd      ?
        card18Y2       dd      ?

        card19X1       dd      ?
        card19Y1       dd      ?
        card19X2       dd      ?
        card19Y2       dd      ?

        card20X1       dd      ?
        card20Y1       dd      ?
        card20X2       dd      ?
        card20Y2       dd      ?

        card21X1       dd      ?
        card21Y1       dd      ?
        card21X2       dd      ?
        card21Y2       dd      ?

        card22X1       dd      ?
        card22Y1       dd      ?
        card22X2       dd      ?
        card22Y2       dd      ?

        card23X1       dd      ?
        card23Y1       dd      ?
        card23X2       dd      ?
        card23Y2       dd      ?

        card24X1       dd      ?
        card24Y1       dd      ?
        card24X2       dd      ?
        card24Y2       dd      ?

        card25X1       dd      ?
        card25Y1       dd      ?
        card25X2       dd      ?
        card25Y2       dd      ?
        
        card26X1       dd      ?
        card26Y1       dd      ?
        card26X2       dd      ?
        card26Y2       dd      ?

        card27X1       dd      ?
        card27Y1       dd      ?
        card27X2       dd      ?
        card27Y2       dd      ?

        card28X1       dd      ?
        card28Y1       dd      ?
        card28X2       dd      ?
        card28Y2       dd      ?

        card29X1       dd      ?
        card29Y1       dd      ?
        card29X2       dd      ?
        card29Y2       dd      ?

        card30X1       dd      ?
        card30Y1       dd      ?
        card30X2       dd      ?
        card30Y2       dd      ?

        card31X1       dd      ?
        card31Y1       dd      ?
        card31X2       dd      ?
        card31Y2       dd      ?

        card32X1       dd      ?
        card32Y1       dd      ?
        card32X2       dd      ?
        card32Y2       dd      ?


card1BrdrHandler         dd      0
card2BrdrHandler         dd      0
card3BrdrHandler         dd      0
card4BrdrHandler         dd      0
card5BrdrHandler         dd      0
card6BrdrHandler         dd      0
card7BrdrHandler         dd      0
card8BrdrHandler         dd      0
cardB9rdrHandler         dd      0
card10BrdrHandler         dd      0
card11BrdrHandler         dd      0
card12BrdrHandler         dd      0
card13BrdrHandler         dd      0
card14BrdrHandler         dd      0
card15BrdrHandler         dd      0
card16BrdrHandler         dd      0
card17BrdrHandler         dd      0
card18BrdrHandler         dd      0
card19BrdrHandler         dd      0
card20BrdrHandler         dd      0
card21BrdrHandler         dd      0
card22BrdrHandler         dd      0
card23BrdrHandler         dd      0
card24BrdrHandler         dd      0
card25BrdrHandler         dd      0
card26BrdrHandler         dd      0
card27BrdrHandler         dd      0
card28BrdrHandler         dd      0
card29BrdrHandler         dd      0
card30BrdrHandler         dd      0
card31BrdrHandler         dd      0
card32BrdrHandler         dd      0


oone    equ     1
zero   equ     0

vvvv0   equ  -100.0, -100.0, 0 
vvvv1   equ   -100.0, 100.0, 0
vvvv2   equ     100.0, 100.0, 0
vvvv3   equ     100.0, -100.0 ,0
cubeVertices    dd      vvvv0, vvvv1, vvvv3,\  
                        vvvv1, vvvv2, vvvv3
 

cubeTexVerts    dd      0, 0, 0, 1.0, 1.0, 0,\
                        0, 1.0, 1.0, 1.0, 1.0, 0