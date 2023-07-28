    CardVertCount     dd       108


            ;       x    y   z
    v0      equ     2.0, 0.0, 0.0
    v1      equ     2.0, 2.0, 0.0
    v2      equ     0.0, 2.0, 2.0
    v3      equ     0.0, 0.0, 2.0
    v4      equ     30.0, 0.0, 2.0
    v5      equ     30.0, 2.0, 2.0
    v6      equ     28.0, 2.0, 0.0
    v7      equ     28.0, 0.0, 0.0
    v8      equ     28.0, 0.0, 42.0
    v9      equ     28.0, 2.0, 42.0
    v10     equ     30.0, 2.0, 40.0
    v11     equ     30.0, 0.0, 40.0
    v12     equ     0.0, 0.0, 40.0
    v13     equ     0.0, 2.0, 40.0
    v14     equ     2.0, 2.0, 42.0
    v15     equ     2.0, 0.0, 42.0
    v16     equ     2.0, 2.0, 2.0
    v17     equ     28.0, 2.0, 2.0
    v18     equ     28.0, 2.0, 40.0
    v19     equ     2.0, 2.0, 40.0
    v20     equ     2.0, 0.0, 2.0
    v21     equ     28.0, 0.0, 2.0
    v22     equ     28.0, 0.0, 40.0
    v23     equ     2.0, 0.0, 40.0

    cardVertices    dd      v0, v1, v2,\ ; chamfers
                            v0, v2, v3,\
                            v4, v5, v6,\
                            v4, v6, v7,\
                            v8, v9, v10,\
                            v8, v10, v11,\
                            v12, v13, v14,\ 
                            v12, v14, v15,\     
                            v1, v2, v16,\ ; above chamfers
                            v5, v6, v17,\
                            v9, v10, v18,\
                            v13, v14, v19,\
                            v0, v3, v20,\ ; below chamfers
                            v4, v7, v21,\
                            v8, v11, v22,\ 
                            v12, v15, v23,\ 
                            v1, v6, v16,\ ; prolonged north up & down
                            v6, v16, v17,\
                            v0, v7, v20,\
                            v4, v20, v21,\ 
                            v9, v14, v18,\ ; prolonged south up & down
                            v14, v18, v19,\
                            v8, v15, v22,\ 
                            v15, v22, v23,\
                            v2, v5, v13,\ ; big north up & down
                            v3, v4, v12,\ 
                            v5, v10, v13,\
                            v4, v11, v12,\ 
                            v0, v1, v7,\ ; side north 
                            v1, v6, v7,\
                            v4, v5, v11,\ ; side east
                            v5, v10, v11,\ 
                            v8, v9, v15,\ ; side south
                            v9, v14, v15,\  
                            v2, v3, v13,\ ; side west
                            v3, v12, v13




    cardColors      dd      18       dup     (1.0, 0.0, 0.0),\
                            18       dup     (1.0, 1.0, 0.0),\
                            18       dup     (0.0, 1.0, 0.0),\
                            18       dup     (1.0, 0.0, 1.0),\
                            18       dup     (0.0, 0.0, 1.0),\
                            18       dup     (0.0, 1.0, 1.0)
    

