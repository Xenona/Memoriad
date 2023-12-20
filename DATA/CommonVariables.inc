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
windowID                dd      0                    ; shows, which game screen should be drawn 
objectNumSelected       dd      -1
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

cardBackTextureFile db ".\ASSETS\INGAME\CARDBACK.bmp", 0
cardsPath db ".\ASSETS\CARDS\*.bmp", 0
cardsFolderPath db "ASSETS\CARDS\", 0
filenamesArrayHandle dd 0
numberOfFiles dd 0
cardBackTexHandle dd 0
arrTextures dd 32 dup (0)
arrTexturesInit dd 32 dup (0)
musicOpen db "open .\ASSETS\INGAME\awaken-136824.mp3 type mpegvideo alias mp3", 0
musicPlay db "play mp3 repeat", 0
musicStop db "stop mp3", 0
musicClose db "close mp3", 0
playing     db 1
hertz   dd 1900
musicStartTime dd 0
musicLen    dd  1000*3*60

;______________________________________________________________________________ 

;__WINDOW 2 (CARDS SELECTION)__________________________________________________

topScrollLevel dd 83.0
currentScrollLevel dd 0 
brush dd 0
currTexArray dd 12 dup (0)
paletteYOffset dd -8.5
paletteXOffset dd 15.0
currentPage     dd  0
NUM_OF_FILES_ON_A_PAGE = 12



;______________________________________________________________________________ 

