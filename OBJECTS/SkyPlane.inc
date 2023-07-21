    SkyPlaneVertCount dd 63

    sky0    equ     -110.0, -12.0, 0.0
    sky1    equ     -110.0, -4.8 , 0.0
    sky2    equ     -110.0, 9.6, 0.0
    sky3    equ     -110.0, 16.8, 0.0
    sky4    equ     -110.0, 24.0, 0.0
    sky5    equ     -110.0, 31.2, 0.0
    sky6    equ     -110.0, 45.6, 0.0
    sky7    equ     -110.0, 60.0, 0.0
    sky8    equ     110.0, 60.0, 0.0
    sky9    equ     110.0, 45.6, 0.0
    sky10   equ     110.0, 31.2, 0.0
    sky11   equ     110.0, 24.0, 0.0
    sky12   equ     110.0, 16.8, 0.0
    sky13   equ     110.0, 9.6, 0.0
    sky14   equ     110.0, -4.8, 0.0
    sky15   equ     110.0, -12.0, 0.0
    sky16   equ     0.0, -12.0, 0.0
    sky17   equ     0.0, -4.8, 0.0
    sky18   equ     0.0, 9.6, 0.0
    sky19   equ     0.0, 16.8, 0.0
    sky20   equ     0.0, 24.0, 0.0
    sky21   equ     0.0, 31.2, 0.0
    sky22   equ     0.0, 45.6, 0.0


    darkBlue    equ     0.0, 0.1294, 0.2196
    blue        equ     0.33, 0.4, 1.0
    liBlue      equ     0.3921, 0.745, 1.0
    green       equ     0.6039, 1.0, 0.5411 
    yellow      equ     0.9608, 0.886, 0.196
    orange      equ     1.0, 0.6039, 0.1412 
    red         equ     0.9921, 0.0, 0.0



    skyVertices    dd  sky7, sky8, sky22,\ ; downwards turned
                       sky6, sky9, sky21,\
                       sky5, sky10, sky20,\
                       sky4, sky11, sky19,\
                       sky3, sky12, sky18,\
                       sky2, sky13, sky17,\
                       sky1, sky14, sky16,\
                       sky0, sky1, sky16,\ ; leftwards turned
                       sky1, sky2, sky17,\
                       sky2, sky3, sky18,\
                       sky3, sky4, sky19,\
                       sky4, sky5, sky20,\
                       sky5, sky6, sky21,\
                       sky6, sky7, sky22,\ 
                       sky8, sky9, sky22,\ ; rightwards turned
                       sky9, sky10, sky21,\
                       sky10, sky11, sky20,\
                       sky11, sky12, sky19,\
                       sky12, sky13, sky18,\
                       sky13, sky14, sky17,\
                       sky14, sky15, sky16


    skyColors      dd  darkBlue, darkBlue, darkBlue,\
                       darkBlue, darkBlue, blue,\
                       blue, blue, liBlue,\
                       liBlue, liBlue, green,\
                       green, green, yellow,\
                       yellow, yellow, orange,\
                       orange, orange, red,\
                       red, orange, red,\
                       orange, yellow, orange,\
                       yellow, green, yellow,\
                       green, liBlue, green,\
                       liBlue, blue, liBlue,\
                       blue, darkBlue, blue,\
                       darkBlue, darkBlue, darkBlue,\
                       darkBlue, darkBlue, darkBlue,\
                       darkBlue, blue, blue,\
                       blue, liBlue, liBlue,\
                       liBlue, green, green,\
                       green, yellow, yellow,\
                       yellow, orange, orange,\
                       orange,red, red
