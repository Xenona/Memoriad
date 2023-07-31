sunPlaneVertCount dd 15

sunZeroPoint equ 0.0

    ; sun0 equ sunZeroPoint, sunZeroPoint, sunZeroPoint
    ; sun1 equ sunZeroPoint+2.58, sunZeroPoint+9.82, sunZeroPoint
    ; sun2 equ sunZeroPoint+9.82, sunZeroPoint+17.22, sunZeroPoint
    ; sun3 equ sunZeroPoint+20.0, sunZeroPoint+20.0, sunZeroPoint
    ; sun4 equ sunZeroPoint+30.0, sunZeroPoint+17.32, sunZeroPoint
    ; sun5 equ sunZeroPoint+37.32, sunZeroPoint+10.0, sunZeroPoint
    ; sun6 equ sunZeroPoint+40.0, sunZeroPoint, sunZeroPoint

    sun0 equ -80.0, -10.0, -1.0
    sun1 equ -77.42, -0.18, -1.0
    sun2 equ -70.18, 7.22, -1.0
    sun3 equ -60.0, 10.0, -1.0
    sun4 equ -50.0, 7.32, -1.0
    sun5 equ -42.68, 0.0, -1.0
    sun6 equ -40.0, -10.0, -1.0

sunVertices         dd  sun0, sun2, sun4,\
                        sun0, sun4, sun6,\
                        sun0, sun1, sun2,\
                        sun2, sun3, sun4,\ 
                        sun4, sun5, sun6

sunColors           dd  red, orange, orange,\
                        red, orange, red,\
                        red, orange, orange,\
                        orange, orange, orange,\
                        orange, orange, red