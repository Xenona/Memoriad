    SeaPlaneVertCount dd 6

    sea0    equ     -110.0, -10.0, -0.000
    sea1    equ      110.0, -10.0, -0.000
    sea2    equ      110.0, -60.0, -0.000
    sea3    equ     -110.0, -60.0, -0.000

    seaVertices    dd  sea0, sea1, sea3,\
                        sea1, sea2, sea3

    seaColors      dd  2 dup (0.0, 0.5, 0.5),\ 
                       1 dup (0.0, 0.2745, 0.2745), 1 dup (0.0, 0.5, 0.5),\
                       2 dup (0.0, 0.2745, 0.2745)

                