skyPlaneVertCount dd 42 ; 7*2*3

    sky0    equ     -110.0, -12.0, -10.0
    sky1    equ     -110.0, -4.8 , -10.0
    sky2    equ     -110.0, 9.6, -10.0
    sky3    equ     -110.0, 16.8, -10.0
    sky4    equ     -110.0, 24.0, -10.0
    sky5    equ     -110.0, 31.2, -10.0
    sky6    equ     -110.0, 45.6, -10.0
    sky7    equ     -110.0, 60.0, -10.0
    sky8    equ     110.0, 60.0, -10.0
    sky9    equ     110.0, 45.6, -10.0
    sky10   equ     110.0, 31.2, -10.0
    sky11   equ     110.0, 24.0, -10.0
    sky12   equ     110.0, 16.8, -10.0
    sky13   equ     110.0, 9.6, -10.0
    sky14   equ     110.0, -4.8, -10.0
    sky15   equ     110.0, -12.0, -10.0

skyVertices         dd  sky0, sky1, sky14,\
                        sky0, sky14,sky15,\
                        sky1, sky2, sky13,\
                        sky1, sky13,sky14,\
                        sky2, sky3, sky12,\
                        sky2, sky12,sky13,\
                        sky3, sky4, sky11,\
                        sky3, sky11,sky12,\
                        sky4, sky5, sky10,\
                        sky4, sky10,sky11,\
                        sky5, sky6, sky9,\
                        sky5, sky9, sky10,\
                        sky6, sky7, sky8,\
                        sky6, sky8, sky9



    darkBlue    equ     0.0, 0.1294, 0.2196
    blue        equ     0.33, 0.4, 1.0
    liBlue      equ     0.3921, 0.745, 1.0
    green       equ     0.6039, 1.0, 0.5411 
    yellow      equ     0.9608, 0.886, 0.196
    orange      equ     1.0, 0.6039, 0.1412 
    red         equ     0.9921, 0.0, 0.0

skyColors           dd  red, orange, orange,\
                        red, orange, red,\
                        orange, yellow, yellow,\
                        orange, yellow, orange,\
                        yellow, green, green,\
                        yellow, green, yellow,\
                        green, liBlue, liBlue,\
                        green, liBlue, green,\
                        liBlue, blue, blue,\
                        liBlue, blue, liBlue,\
                        blue, darkBlue, darkBlue,\
                        blue, darkBlue, blue,\
                        darkBlue, darkBlue, darkBlue,\
                        darkBlue, darkBlue, darkBlue






