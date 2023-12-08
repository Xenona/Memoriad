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
camAngleStep            dd              3.14;0.01745320
camViewRadius           dd              25.0
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
Window2.Congrats        db      "CONGRATS FOR YOU, O WINNER!!!", 0
Window2.ItTook          db      "IT TOOK", 0
Window2.Number          db      "                  ", 0
Window2.MovesToWin      db      "MOVES FOR YOU TO WIN", 0
Window2.Custom0         db      "SOMEDAY YOU WILL BECOME A LEGEND", 0
Window2.Custom1         db      "THAT'S NICE TRY, YOU MADE IT WELL!", 0
Window2.Custom2         db      " YOU DEFINITELY COULD DO IT BETTER", 0
Window2.Custom3         db      "HOLY MOLY, IT TOOK SO LONG, MAN...", 0
Window2.ExitHint        db      "press any key to exit to main menu.", 0

;______________________________________________________________________________  


;__CARDS AND STUFF_____________________________________________________________
cardsMatch              dd      0 
timeOfStart             dd      -1
NUM_OF_VERTS_FOR_CARD_BORDERS       =       16 * 3
NUM_OF_VERTS_FOR_CARD_FACE          =       10 * 3    
NUM_OF_VERTS_FOR_CARD_BACK          =       10 * 3    
;______________________________________________________________________________


;__TEXTURES: FILENAMES AND ARRAYS______________________________________________ 


    testPic2 db 'ASSETS\CARDS\test2.bmp', 0
    testPic3 db 'ASSETS\CARDS\test3.bmp', 0
    testPic4 db 'ASSETS\CARDS\test4.bmp', 0
    testPic5 db 'ASSETS\CARDS\test5.bmp', 0
    testPic6 db 'ASSETS\CARDS\test6.bmp', 0
    testPic7 db 'ASSETS\CARDS\test7.bmp', 0
    testPic8 db 'ASSETS\CARDS\test8.bmp', 0
    testPic9 db 'ASSETS\CARDS\test9.bmp', 0
    testPic10 db 'ASSETS\CARDS\testa.bmp', 0
    testPic11 db 'ASSETS\CARDS\testb.bmp', 0
    testPic12 db 'ASSETS\CARDS\testc.bmp', 0
    testPic13 db 'ASSETS\CARDS\testd.bmp', 0
    testPic14 db 'ASSETS\CARDS\teste.bmp', 0
    testPic15 db 'ASSETS\CARDS\testk.bmp', 0
    testPic16 db 'ASSETS\CARDS\testf.bmp', 0
    testPic17 db 'ASSETS\CARDS\testg.bmp', 0
    testPic18 db 'ASSETS\CARDS\testh.bmp', 0
    testPic19 db 'ASSETS\CARDS\testi.bmp', 0
    testPic20 db 'ASSETS\CARDS\testj.bmp', 0
    testPic21 db 'ASSETS\CARDS\testk.bmp', 0
    testPic22 db 'ASSETS\CARDS\testl.bmp', 0
    testPic23 db 'ASSETS\CARDS\testm.bmp', 0
    testPic24 db 'ASSETS\CARDS\testn.bmp', 0
    testPic25 db 'ASSETS\CARDS\testo.bmp', 0
    testPic26 db 'ASSETS\CARDS\testp.bmp', 0
    testPic27 db 'ASSETS\CARDS\testq.bmp', 0
    testPic28 db 'ASSETS\CARDS\testr.bmp', 0
    testPic29 db 'ASSETS\CARDS\tests.bmp', 0
    testPic30 db 'ASSETS\CARDS\testt.bmp', 0
    testPic31 db 'ASSETS\CARDS\testu.bmp', 0
    testPic32 db 'ASSETS\CARDS\testv.bmp', 0
    testPic33 db 'ASSETS\CARDS\testw.bmp', 0

arrTextures dd 32 dup (?)
cardBackTextureFile db ".\ASSETS\INGAME\CARDBACK.bmp", 0
cardBackTexHandle dw ?
cardsPath db "C:\Users\golub\Desktop\Memoriad\ASSETS\CARDS\*.bmp", 0
cardsFolderPath db "ASSETS\CARDS\", 0
;______________________________________________________________________________ 
