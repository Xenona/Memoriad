    CardVertCount     dd       108

    card0      equ     2.0, 0.0, 0.0
    card1      equ     2.0, 0.0, 2.0
    card2      equ     0.0, 2.0, 2.0
    card3      equ     0.0, 2.0, 0.0
    card4      equ     30.0, 2.0, 0.0
    card5      equ     30.0, 2.0, 2.0
    card6      equ     28.0, 0.0, 2.0
    card7      equ     28.0, 0.0, 0.0
    card8      equ     28.0, 42.0, 0.0
    card9      equ     28.0, 42.0, 2.0
    card10     equ     30.0, 40.0, 2.0
    card11     equ     30.0, 40.0, 0.0
    card12     equ     0.0, 40.0, 0.0
    card13     equ     0.0, 40.0, 2.0
    card14     equ     2.0, 42.0, 2.0
    card15     equ     2.0, 42.0, 0.0
    card16     equ     2.0, 2.0, 2.0
    card17     equ     28.0, 2.0, 2.0
    card18     equ     28.0, 40.0, 2.0
    card19     equ     2.0, 40.0, 2.0
    card20     equ     2.0, 2.0, 0.0
    card21     equ     28.0, 2.0, 0.0
    card22     equ     28.0, 40.0, 0.0
    card23     equ     2.0, 40.0, 0.0

    cardVertices    dd      card0, card1, card2,\ ; chamfers
                            card0, card2, card3,\
                            card4, card5, card6,\
                            card4, card6, card7,\
                            card8, card9, card10,\
                            card8, card10,card11,\
                            card12, card13, card14,\ 
                            card12, card14, card15,\     
                            card1, card2, card16,\ ; above chamfers
                            card5, card6, card17,\
                            card9, card10, card18,\
                            card13,card14,card19,\
                            card0, card3, card20,\ ; below chamfers
                            card4, card7, card21,\
                            card8, card11,card22,\ 
                            card12, card15, card23,\ 
                            card1, card6, card16,\ ; prolonged north up & down
                            card6, card16, card17,\
                            card0, card7, card20,\
                            card4, card20, card21,\ 
                            card9, card14, card18,\ ; prolonged south up & down
                            card14, card18, card19,\
                            card8, card15, card22,\ 
                            card15, card22, card23,\
                            card2, card5, card13,\ ; big north up & down
                            card3, card4, card12,\ 
                            card5, card10, card13,\
                            card4, card11, card12,\ 
                            card0, card1, card7,\ ; side north 
                            card1, card6, card7,\
                            card4, card5, card11,\ ; side east
                            card5, card10, card11,\ 
                            card8, card9, card15,\ ; side south
                            card9, card14, card15,\  
                            card2, card3, card13,\ ; side west
                            card3, card12, card13




    cardColors      dd      18       dup     (1.0, 0.0, 0.0),\
                            18       dup     (1.0, 1.0, 0.0),\
                            18       dup     (0.0, 1.0, 0.0),\
                            18       dup     (1.0, 0.0, 1.0),\
                            18       dup     (0.0, 0.0, 1.0),\
                            18       dup     (0.0, 1.0, 1.0)
    

        cardX1   dd      0.0
        cardY1   dd      0.0
        cardZ1   dd      1.0

        cardX2   dd      30.0
        cardY2   dd      42.0
        cardZ2   dd      1.0

        distX   dd      50.0
        distY   dd      47.0
        
        cardWidth       dd      30.0
        cardHeight      dd      42.0
cardBrdrHandler         dd      0