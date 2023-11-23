
testPic2 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test2.bmp', 0
testPic3 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test3.bmp', 0
testPic4 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test4.bmp', 0
testPic5 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test5.bmp', 0
testPic6 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test6.bmp', 0
testPic7 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test7.bmp', 0
testPic8 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test8.bmp', 0
testPic9 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test9.bmp', 0
testPic10 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\testa.bmp', 0
testPic11 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\testb.bmp', 0
testPic12 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\testc.bmp', 0
testPic13 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\testd.bmp', 0
testPic14 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\teste.bmp', 0
testPic15 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\testk.bmp', 0
testPic16 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\testf.bmp', 0
testPic17 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\testg.bmp', 0
testPic18 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\testh.bmp', 0
testPic19 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\testi.bmp', 0
testPic20 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\testj.bmp', 0
testPic21 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic22 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic23 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic24 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic25 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic26 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic27 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic28 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic29 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic30 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic31 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic32 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
testPic33 db 'C:\Users\golub\Desktop\Memoriad\ASSETS\test1.bmp', 0
arrTextures dd 32 dup (?)




;__FOR MAIN WINDOW MAINTENANCE_________________________________________________    
COLOR_DEPTH             =       24
PFD_FLAGS               =       PFD_SUPPORT_OPENGL or PFD_DOUBLEBUFFER or PFD_DRAW_TO_WINDOW
WINDOW_STYLE            =       WS_VISIBLE or WS_MAXIMIZE or WS_POPUP
FOV                     =       60.0
Z_NEAR                  =       0.001
Z_FAR                   =       10000.0

wndClass                WNDCLASS                0, WindowProc, 0, 0, 0, 0, 0, 0, 0, className
pfd                     PIXELFORMATDESCRIPTOR   sizeof.PIXELFORMATDESCRIPTOR, 1,\
                                                PFD_FLAGS, PFD_TYPE_RGBA, COLOR_DEPTH,\
                                                0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,\
                                                COLOR_DEPTH, 0, 0, PFD_MAIN_PLANE, 0, PFD_MAIN_PLANE

className               db      "MEMORIAD (C) XENONA GAMES 2023", 0
clientRect              RECT
hdc                     dd      ?
aspect                  dq      ?                       ; width/height 
windowID                dd      1                       ; shows, which game screen should be drawn
objectNumSelected       dd      -1
hinst                   dd      ?
hCurs1                  dd      ?
hCurs2                  dd      ?

;______________________________________________________________________________    



;__FOR IMITATING WAVES ON A SEA ON WINDOW0 (MAIN MENU)_________________________    

waveX                   dd      0.01                    ; current x on x-axis
waveStep                dd      0.08                    ; step for current x 
waveSin                 dd      ?                       ; value of sin(curr x)
;______________________________________________________________________________    



;__WORKING WITH OPENGL_________________________________________________________    
currMode                dd      ?
matrixWtS               matrix                          ; type defined in Matrix.inc
trMatr                  matrix                         ; matrix for all transformations

cameraPos           	vector3         ?, ?, ? 
targetPos  	            vector3         ?, ?, ? 
upVector 	            vector3         0.0, 1.0, 0.0                      
camAngle                dd              0.01
camAngleStep            dd              0.01745320
camViewRadius           dd              250.0
;______________________________________________________________________________    


;__CONTROLLING USER ACTIONS____________________________________________________    
mouseX                  dd      0 
mouseY                  dd      0
canClick                dd      1
;______________________________________________________________________________    


;__SOME STRINGS TO PRINT_______________________________________________________  
Window0.StartButton     db      "START", 0
Window0.CardsButton     db      "VIEW CARDS", 0
Window0.SettsButton     db      "SETTINGS", 0
Window0.ExitButton      db      "EXIT", 0
Window0.WelcomeText0    db      "WELCOME TO", 0
Window0.WelcomeText1    db      "MEMORIAD", 0

;______________________________________________________________________________    


; __CARDS AND STUFF____________________________________________________________
cardsMatch              dd      0 
timeOfStart             dd      -1
NUM_OF_VERTS_FOR_CARD_BORDERS       =       16 * 3
NUM_OF_VERTS_FOR_CARD_FACE          =       10 * 3    
NUM_OF_VERTS_FOR_CARD_BACK          =       10 * 3    
;______________________________________________________________________________