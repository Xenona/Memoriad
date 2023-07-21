CUBE_VERTICES_COUNT     =       3 * 2 * 6

ZeroPoint equ 1.0

v0              equ     -1.0, -1.0,  1.0
v1              equ     -1.0,  1.0,  1.0
v2              equ      1.0, -1.0,  1.0
v3              equ      ZeroPoint,  1.0,  1.0
v4              equ      1.0, -1.0, -1.0
v5              equ      1.0,  1.0, -1.0
v6              equ     -1.0, -1.0, -1.0
v7              equ     -1.0,  1.0, -1.0

cubeVertices    dd      v2, v3, v1,\
                        v2, v1, v0,\
                        v4, v5, v3,\
                        v4, v3, v2,\
                        v6, v7, v5,\
                        v6, v5, v4,\
                        v0, v1, v7,\
                        v0, v7, v6,\
                        v3, v5, v7,\
                        v3, v7, v1,\
                        v4, v2, v0,\
                        v4, v0, v6

cubeColors      dd      6       dup     (1.0, 0.0, 0.0),\
                        6       dup     (1.0, 1.0, 0.0),\
                        6       dup     (0.0, 1.0, 0.0),\
                        6       dup     (1.0, 0.0, 1.0),\
                        6       dup     (0.0, 0.0, 1.0),\
                        6       dup     (0.0, 1.0, 1.0)