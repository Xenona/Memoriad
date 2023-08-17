

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
IsCamNeg                dd              0.0
;______________________________________________________________________________    



;__CONTROLLING USER ACTIONS____________________________________________________    
mouseX                  dd      0 
mouseY                  dd      0
;______________________________________________________________________________    




;__SOME STRINGS TO PRINT_______________________________________________________  
Window0.StartButton     db      "START", 0
Window0.CardsButton     db      "VIEW CARDS", 0
Window0.SettsButton     db      "SETTINGS", 0
Window0.ExitButton      db      "EXIT", 0
Window0.WelcomeText0    db      "WELCOME TO", 0
Window0.WelcomeText1    db      "MEMORIAD", 0

;______________________________________________________________________________    
