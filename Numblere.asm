
IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
; Your variables here
; --------------------------
	calcEqArr dw 5 dup (0)
	TempCheckForPlace db 0,0,0,0,0,0,0,0    ;0 for doesnt exist, 1 for wrong place , 2 for right place
	TheWinningEq db ?,?,?,?,?,?,?,?
	randomNumber db ?
	arrPeola db '+','-','*','/','='
	
	x dw 50
	y dw 0
	ogY dw 0

	outputEnter db 'Enter$'
	outputDelete db 'Delete$'
	
	currentBoxOutput dw 0  ;;; each row is 8 box last box is 40
	currentBoxOutputStartX dw 50
	currentBoxOutputEndX dw 75
	currentBoxOutputStartY dw 0
	currentBoxOutputEndY dw  25
	printinBox db ?
	printBoxColor dw ?
	

	tempMatX db ?
	tempMatY db ?
	OutputRowArray db 1,5,8,11,15
	OutputColArray db 7,11,15,18,21,25,28,32
	
	tempEq db ?,?,?,?,?,?,?,?
	tempEqPointer dw 0
	

	;colors:
	ColorInput dw 19h ;color input buttons
	colorOutput dw 19h ;color output boxes
	colorBackground dw 00h ;the  color of the background
	colorCorrectPlace dw 2
	colorPlaceNO dw 2bh
	ColorNOnum dw 15h
	
	counterPeolaCheck db 0
	
	tempCol db 1
	tempRow db 15
	tempText db 'd'
	
	tempCx dw 69    ;starting point for the mouse position
	tempDx dw 69
	
	endProgram db 0
	counterWinning db 0

	
	Eq1  db 9  ,'+' ,8   ,'-',2  ,'=',1  ,5
	Eq2  db 8  ,'*' ,2   ,'-',1  ,6  ,'=',0
	Eq3  db 4  ,8   ,'/' ,8  ,'/',1  ,'=',6
	Eq4  db 1  ,4   ,'/' ,7  ,'+',4  ,'=',6
	Eq5  db 9  ,9   ,'*' ,4  ,'=',3  ,9  ,6
	Eq6  db 3  ,5   ,7   ,'/',7  ,'=',5  ,1
	Eq7  db 6  ,9   ,'-' ,4  ,2  ,'=',2  ,7
	Eq8  db 4  ,'*' ,8   ,1  ,'=',3  ,2  ,4
	Eq9  db 5  ,6   ,'/' ,8  ,'-',5  ,'=',2
	Eq10 db 9  ,'*' ,4   ,'+',2  ,'=',3  ,8
	Eq11 db 2  ,7   ,'/' ,3  ,'-',8  ,'=',1
	Eq12 db 5  ,2   ,'+' ,3  ,1  ,'=',8  ,3
	Eq13 db 2  ,1   ,6   ,'/',8  ,'=',2  ,7
	Eq14 db 9  ,6   ,'+' ,9  ,'=',1  ,0  ,5
	Eq15 db 1  ,2   ,'-' ,4  ,'-',2  ,'=',6
	Eq16 db 9  ,'*' ,2   ,'+'  ,6,'='  ,2,4
	
	Start_message db 'Welcome to my game',10 ,13 ,'$'
	Start_message1 db 'Here are the rules:',10 ,13 ,'$'
	Rule_Message1 db 'Each guess is a calculation.',10 ,13 ,'$'
	Rule_Message2 db 'The order of operations does not apply.',10 ,13 ,'$'
	Rule_Message3 db 'The numbers must be positive.',10 ,13 ,'$'
	Rule_Message4 db 'You cant divide with Remainder',10 ,13 ,'$'
	Rule_Message5A db 'It must only have a number to the right of the "=",not another calculation.',10 ,13 ,'$'
	Rule_Message5B db 'It must contain one "=".',10 ,13 ,'$'
	Rule_MessageClear db '',10 ,13 ,10 ,13,'$'
	Continue_message db 'To continue press the spacebar',10 ,13 ,'$'

	
	VictoryText db 'You won!',3,13,10,13,10, " press y to play again or n to exit ",13,10, '$' ; victory text
	LoserText db 'You lost ',2,13,10,13,10, " press y to play again or n to exit ",13,10, '$' ; victory text

;================================================================================================================================================
CODESEG 
;================================================================================================================================================


proc Game_Starter
	push bp
	mov bp, sp
	mov dx, offset Start_message
	mov ah, 9h
	int 21h
	mov dx, offset Start_message1
	mov ah, 9h
	int 21h
	;new line
	mov dl, 10
	mov ah, 2
	int 21h
	;print the rules
	mov dx, offset Rule_Message1
	mov ah, 9h
	int 21h
	mov dx, offset Rule_Message2
	mov ah, 9h
	int 21h
	mov dx, offset Rule_Message3
	mov ah, 9h
	int 21h
	mov dx, offset Rule_Message4
	mov ah, 9h
	int 21h
	mov dx, offset Rule_Message5A
	mov ah, 9h
	int 21h
	mov dx, offset Rule_Message5B
	mov ah, 9h
	int 21h
	mov dx, offset Rule_MessageClear
	mov ah, 9h
	int 21h
	mov dx, offset Continue_message
	mov ah, 9h
	int 21h
	xor ah,ah ;  ;wait for keypress to start the game
	int 16h
	pop bp
	ret
endp Game_Starter



proc The_Great_Reset

	push 15
	call randomEq
	mov [counterWinning],0
	mov [currentBoxOutput],0
	mov [counterPeolaCheck],0
	mov [x],50
	mov [y],0
	mov [ogY],0
	mov [tempEqPointer],0
	mov [endProgram],0
	xor ax,ax
	xor bx,bx
	xor cx,cx
	xor di,di
	xor dx,dx
	xor si,si
	
ret
endp The_Great_Reset


proc    printButtonsAndSlots
    ;Print a rectangle in any place given and any color given
    push bp
    mov bp, sp
    push cx
	push bx
    startXParm equ [bp + 12]
    startYParm equ [bp + 10]
    endXParm equ [bp + 8]
    endYParm equ [bp + 6]
    colorParm equ [bp + 4]

    mov cx, endYParm
    sub cx, startYParm
    xor di, di

printButtonsAndSlotsLines:
    push cx
    mov cx, endXParm
    sub cx, startXParm
    xor si, si
    
printButtonsAndSlotsLine:
    push cx
    xor bh, bh
    mov cx, startXParm
    add cx, si
    mov dx, startYParm
    add dx, di
    mov ax, colorParm
    mov ah, 0Ch
    int 10h
    inc si
    pop cx
    loop printButtonsAndSlotsLine
    inc di
    pop cx
    loop printButtonsAndSlotsLines
    pop bx
	pop cx
    pop bp
    ret 10
endp    printButtonsAndSlots

proc printMatrix   ; proc that prints matrix, its given Row col and text 
	push bp
	mov bp, sp
	mov dl,[bp+8]
	mov [tempCol],dl;
	mov dl,[bp+6]
	mov [tempRow],dl;
	mov dl,[bp+4]
	mov [tempText],dl;
	mov dl, [tempCol]; collom- till 39
	mov dh, [tempRow];row - til 24
	xor bh,bh ; display page
	mov ah, 2h ; set curser position
	int 10h      ;set the position of the text
	mov ah,2h
	mov dl, [tempText]
	int 21h  ;print the text
pop bp
ret 6	
endp printMatrix

proc	PrintBackGround
	;;;;;;;;;;;;;;;;;Print the BackGround to black
	mov ah, 6h
	xor al, al
	xor cx, cx
	mov dx, 184Fh
	mov bx,[colorBackground] ;0h
	mov bh, bl
	int 10h
	ret
endp	PrintBackGround

proc	PrintOutPutBoard
	;;;;;;;;;;;;;;;;;;;;print Board  
	mov bx,5
	printBoardA:
	mov cx,8
	printBoardB:
	push [x] ;startx
	push [y] ;starty
	add [x],25
	add [y],25
	push [x] ;endx
	push [y] ;endy
	sub [y],25
	push [colorOutput] ;0c0h  ;color
	add [x],3
	call printButtonsAndSlots
	loop printBoardB
	mov [x],50
	add [ogY], 28
	mov ax, [ogY]
	mov [y], ax
	dec bx
	cmp bx,0
	jne printBoardA
	ret 
endp	PrintOutPutBoard
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



proc	PrintInputRow1
	;;;;;;;;;;;;;;;;;;;;;;;;;draw boxes for input row 1
	mov [x], 22
	mov [y], 146
	mov cx,10
	printButtonRow1:
	push [x] ;startx
	push [y] ;starty
	add [x],25
	add [y],25
	push [x] ;endx
	push [y] ;endy
	sub [y],25
	push [ColorInput]  ;color
	call printButtonsAndSlots
	add [x],3
	loop printButtonRow1
	
	push 4       ;print the number on the input boxes
	push 19
	push '0' 
	call printMatrix
	push 8
	push 19
	push '1'
	call printMatrix
	push 11
	push 19
	push '2'
	call printMatrix
	push 14
	push 19
	push '3'
	call printMatrix
	push 18
	push 19
	push '4'
	call printMatrix
	push 21
	push 19
	push '5'
	call printMatrix
	push 25
	push 19
	push '6'
	call printMatrix
	push 28
	push 19
	push '7'
	call printMatrix
	push 32
	push 19
	push '8'
	call printMatrix
	push 36
	push 19
	push '9'
	call printMatrix
	ret
endp	PrintInputRow1

proc	PrintInputRow2
	mov [x], 44
	mov [y], 174
	mov cx,5
	printButtonRow2:
	push [x] ;startx
	push [y] ;starty
	add [x],25
	add [y],25
	push [x] ;endx
	push [y] ;endy
	sub [y],25
	push [ColorInput]  ;color
	call printButtonsAndSlots
	add [x],3
	loop printButtonRow2

	push 184 ;startx     ;print the enter button
	push 174 ;starty
	push 228 ;endx
	push 199 ;endy
	push [ColorInput]  ;color
	call printButtonsAndSlots

	push 231 ;startx  ;print the delete button
	push 174 ;starty
	push 281 ;endx
	push 199 ;endy
	push [ColorInput]  ;color
	call printButtonsAndSlots
	
	push 6
	push 23
	push '+'
	call printMatrix
	push 10
	push 23
	push '-'
	call printMatrix
	push 14
	push 23
	push '*'
	call printMatrix
	push 17
	push 23
	push '/'
	call printMatrix
	push 21
	push 23
	push '='
	call printMatrix
	mov dl,23; collom- till 39
	mov dh, 23;row - til 24
	xor bh,bh ; display page
	mov ah, 2h ; set curser position
	int 10h
	mov ah,9h
	mov dx, offset outputEnter
	int 21h
	mov dl,29; collom- till 39
	mov dh, 23;row - til 24
	xor bh,bh ; display page
	mov ah, 2h ; set curser position
	int 10h
	mov ah,9h
	mov dx, offset outputDelete
	int 21h
	
ret
endp	PrintInputRow2

proc MouseInput ;;;;;;;proc for mouse and the boxes input
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;mouse
	; Initializes the mouse
	xor ax,ax
	int 33h
	; Show mouse
	mov ax,1h
	int 33h
	
	mov ax,4             ;set mouse position
	mov cx,[tempCx]
	mov dx,[tempDx]
	int 33h

	; Loop until mouse click
MouseLP :
	mov ax,3h
	int 33h

	and bx,1
	cmp bx, 01h ; check left mouse click
	jne MouseLP

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; check which box is pressed 
	mov ax, 2h
	int 33h;hide mouse
	
PressedBox:   ;;; check which row is pressed and send to its label

	mov [tempCx],cx   ;save mouse position for next Button
	mov [tempDx],dx
	
	shr cx,1 ; adjust cx to range 0-319, to fit screen
	;;check row1
	cmp dx,146
	jnb midjmp1
	jmp MouseLP2
midjmp1:	
	cmp dx,171
	jb inputRow1
	;;;check row2
	cmp dx,174
	jnb midjmp2
	jmp MouseLP2
midjmp2:
	cmp dx,200 ; dosent work the pixel 200 count as row 2
	jne midjmp3
	jmp MouseLP2
midjmp3:
	jmp inputRow2
	
inputRow1:   ;;;;check which box is pressed in row 1 and send to its label
	cmp [currentBoxOutput],40
	je MouseLP
	cmp [tempEqPointer],8
	jae procExit1
	
	cmp cx,22
	jb MouseLP2
	cmp cx,47
	jb Button0
	cmp cx,50
	jb MouseLP2
	cmp cx,75
	jb Button1
	cmp cx,78
	jb MouseLP2
	cmp cx,103
	jb Button2
	cmp cx,106
	jb MouseLP2
	cmp cx,131
	jb Button3
	cmp cx,134
	jb MouseLP2
	cmp cx,159
	jb Button4
	cmp cx,162
	jb MouseLP2
	cmp cx,187
	jb Button5
	cmp cx,190
	jb MouseLP2
	cmp cx,215
	jb Button6
	cmp cx,218
	jb MouseLP2
	cmp cx,243
	jb Button7
	cmp cx,246
	jb MouseLP2
	cmp cx,271
	jb Button8
	cmp cx,274
	jb MouseLP2
	cmp cx,299
	jb Button9
	jmp MouseLP2
	

MouseLP2 :    ;;;; the first MouseLP is out of range and this is a copy of that laber
	mov ax, 1h
	int 33h;show mouse
	jmp MouseLP

procExit1:
jmp procExit

Button0:
	jmp Button20
Button1:
	jmp Button21
Button2:
	jmp Button22
Button3:
	jmp Button23
Button4:
	jmp Button24
Button5:
	jmp Button25
Button6:
	jmp Button26
Button7:
	jmp Button27
Button8:
	jmp Button28
Button9:
	jmp Button29

Button20:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],0
	inc [tempEqPointer]
	push '0' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
Button21:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],1
	inc [tempEqPointer]
	push '1' ;which num to print
	push [colorOutput] ; color	
	call PrintBoxOutput
	jmp ProcExit
Button22:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],2
	inc [tempEqPointer]
	push '2' ;which num to print
	push [colorOutput] ; color	
	call PrintBoxOutput
	jmp ProcExit
Button23:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],3
	inc [tempEqPointer]
	push '3' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
Button24:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],4
	inc [tempEqPointer]
	push '4' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
Button25:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],5
	inc [tempEqPointer]
	push '5' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
Button26:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],6
	inc [tempEqPointer]
	push '6' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
Button27:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],7
	inc [tempEqPointer]
	push '7' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
Button28:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],8
	inc [tempEqPointer]
	push '8' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
Button29:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],9
	inc [tempEqPointer]
	push '9' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit

MouseLP3:
jmp MouseLP2

ProcExit3:
jmp ProcExit

inputRow2:  ;;;;check which box is pressed in row 2 and send to its label
	cmp cx,281
	jg MouseLP3
	cmp cx,231
	jg ButtonDelete
	
	cmp cx,228
	jg MouseLP3
	cmp cx,184
	jg ButtonEnter
	
	cmp [tempEqPointer],8
	jae ProcExit3
	cmp [currentBoxOutput],40
	je MouseLP3
	cmp cx,44
	jb MouseLP3
	cmp cx,69
	jb ButtonPlus
	cmp cx,72
	jb MouseLP3
	cmp cx,97
	jb ButtonMinus
	cmp cx,100
	jb MouseLP3
	cmp cx,125
	jb ButtonMultiply
	cmp cx,128
	jb MouseLP3
	cmp cx,153
	jb ButtonDivide
	cmp cx,156
	jb MouseLP3
	cmp cx,181
	jb ButtonEqual
	cmp cx,184
	jb MouseLP3
	cmp cx,228
	jb ButtonEnter
	cmp cx,231
	jb MouseLP3
	cmp cx,281
	jb ButtonDelete
	jmp MouseLP3


ButtonPlus:
	jmp ButtonPlus2
ButtonMinus:
	jmp ButtonMinus2
ButtonMultiply:
	jmp ButtonMultiply2
ButtonDivide:
	jmp ButtonDivide2
ButtonEqual:
	jmp ButtonEqual2
ButtonEnter:
	jmp ButtonEnter2
ButtonDelete:
jmp ButtonDelete2


ButtonPlus2:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],'+'
	inc [tempEqPointer]
	push '+' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
ButtonMinus2:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],'-'
	inc [tempEqPointer]
	push '-' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
ButtonMultiply2:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],'*'
	inc [tempEqPointer]
	push '*' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
ButtonDivide2:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],'/'
	inc [tempEqPointer]
	push '/' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
ButtonEqual2:
	mov si,[tempEqPointer]      ;add the pressed num to the eq arr
	mov [tempEq+si],'='
	inc [tempEqPointer]
	push '=' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	jmp ProcExit
ButtonEnter2:
	
	cmp [tempEqPointer],8
	jne ProcExit
	
	call checkInputEq
	jmp ProcExit
	
ButtonDelete2:
	cmp [tempEqPointer] , 0
	je procExit
	dec [tempEqPointer]
	sub [currentBoxOutput],1
	push 'L' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	sub [currentBoxOutput],1
	jmp ProcExit
	
ProcExit:
	


ret
endp MouseInput

proc PrintBoxOutput ;proc that given text to print and color. and then print them in the correct box
	push si
	push cx
	push bp
	mov bp,sp
	xor ax,ax
	xor bx,bx
	xor cx,cx

	mov bl,8
	mov dl,[bp+10] ;text to print

	mov [printinBox],dl;what text to print in the box
	mov dx,[bp+8] ;color
	mov [printBoxColor],dx; what color to print the box with
	
	add [currentBoxOutput] , 1   ;add 1 to the next box counter 
	mov [currentBoxOutputStartX],50  ;reset the cords of the box print
	mov [currentBoxOutputEndX],75
	mov [currentBoxOutputStartY],0
	mov [currentBoxOutputEndY],25
	mov ax ,[currentBoxOutput]
	dec ax   ;calc which row and where is the box 
	div bl
	
	mov cl, al
	mov di, cx
	mov dl,[OutputRowArray + di]
	mov [tempMatY],dl
	xor cx,cx
	mov cl, ah
	mov di, cx
	mov dl,[OutputcolArray + di]
	mov [tempMatX],dl
	xor cx,cx
	
	cmp al,0
	je PreXofTheBox
	mov cl,al
YofTheBox: ; add the Y for the box
	add [currentBoxOutputStartY],28
	add [currentBoxOutputEndY],28
loop YofTheBox

cmp ah,0     ;add the x for the box
je PrintTheBox
PreXofTheBox: 
	mov cl,ah
	cmp cx,0
	je PrintTheBox
XofTheBox:
	add [currentBoxOutputStartX],28
	add [currentBoxOutputEndX],28
loop XofTheBox

	
PrintTheBox:  
	push [currentBoxOutputStartX]
	push [currentBoxOutputStartY]
	push [currentBoxOutputEndX]
	push [currentBoxOutputEndY]
	push [printBoxColor]
	call printButtonsAndSlots
	
	cmp [printinBox] , 'L'   ;if its 'L' then its delete button and you dont print the text
	je printTheBoxExit
	mov dl,[tempMatX]; collom- till 39   X   ;print the text on the box
	mov dh, [tempMatY];row - til 24  Y
	xor bh,bh ; display page
	mov ah, 2h ; set curser position
	int 10h
	mov ah,2h
	mov dl, [printinBox]
	int 21h
printTheBoxExit:

pop bp
pop cx
pop si
ret 4
endp PrintBoxOutput



proc checkInputEq   ;proc that use the tempEq arr to check if the input is correct or not
mov [counterPeolaCheck],0

mov si,0      ;loop that check if there is peola in the first or last place
mov bx,0
checkPeola2:
mov di,0
checkPeola1:
	mov al,[tempEq+si]
	cmp al,[arrPeola+di]
	je invalideInput2
	inc di
	cmp di,5
	jne checkPeola1
	mov si,7
	inc bx
	cmp bx,2
	jne checkPeola2
	mov ax,1
	jmp CheckForDoublePeola
	
invalideInput2:
	jmp invalideInput

CheckForDoublePeola:     ; check if there is peola next to peola and if there is atleast 1 peola

	cmp [tempEq+si],'+'
	je ThereIsPeola
	cmp [tempEq+si],'-'
	je ThereIsPeola
	cmp [tempEq+si],'*'
	je ThereIsPeola
	cmp [tempEq+si],'/'
	je ThereIsPeola
	cmp [tempEq+si],'='
	je ThereIsEqual1
	
	cmp [counterPeolaCheck],1   ;if there isnt peola but the counter is 1 then reset
	je decCounterPeolaCheck
	jmp CheckForDoublePeola2
	
decCounterPeolaCheck:    ;reset counter
	dec [counterPeolaCheck]
	jmp CheckForDoublePeola2
ThereIsPeola:
	inc [counterPeolaCheck] ;inc counter
	xor ax,ax   ;check that there is peola 
	jmp CheckForDoublePeola2
	
ThereIsEqual1:   
inc [counterPeolaCheck] ;inc counter

CheckForDoublePeola2:   ;check if the counter is 2 then the eq is invalide
	cmp [counterPeolaCheck],2
	jae invalideInput
	
	
	dec si
	cmp si, 0
	jne CheckForDoublePeola
	cmp ax,1   ;if the ax counter is at 1 then there isnt peola and only equal
	je invalideInput
	
mov si,7             ;check if there is =
xor ax,ax   ;ax is the counter for equals
jmp checkForEqual

thereisEqual:
	mov bx,si
	inc ax  ;inc counter
	jmp checkForEq2
checkForEqual:
	cmp [tempEq+si], '=' 
	je thereisEqual

checkForEq2:
	dec si
	cmp si,0
	jne checkForEqual

	cmp ax,1  ;if there is more than one equal then invalide input
	jne invalideInput
	

mov si,0
checkForDivZero:              ;check if there is / 0 becuse that isnt possible
	cmp [tempEq+si],'/'
	je ThereIsDiv
	jmp checkForDivZero2
ThereIsDiv:
	inc si
	cmp [tempEq+si],0
	je invalideInput
	dec si
checkForDivZero2:
	inc si
	cmp si,7
	jb checkForDivZero

jmp valideInput

invalideInput:
mov cx,8
deleteRow:
	dec [tempEqPointer]
	dec [currentBoxOutput]
	push 'L' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	dec [currentBoxOutput]
	loop deleteRow
	jmp ExitProc
valideInput:
	mov [tempEqPointer],0
	call calcEq
ExitProc:

ret
endp checkInputEq

proc calcEq
	push bp
	mov bp, sp
	sub sp, 2
	Multyplayer equ [word ptr bp-2]
	mov ax, 1
	mov Multyplayer, ax
	dec bx
	mov si,bx
	xor cx,cx
	xor bx,bx
	xor ax,ax
	xor dx,dx

mov bx,0
resetArr:                    ;reset the new calc array to zeros
	mov [calcEqArr+bx],0
	inc bx
	cmp bx,9
	jne resetArr

mov bx, 8 ;Last place in new array
movToDifArr:
	cmp si, 0FFFFh
	je CalcNewEq
	mov di,4
	CheckForPeola1:
		dec di
		mov al,[tempEq+si]
		cmp al,[arrPeola+di]
		je ThereIsPeola1
	CheckForPeolaExit:
		cmp di, 0
		jne CheckForPeola1
thereisNum:
	xor ax, ax
	mov al,[tempEq+si]
	mul Multyplayer
	add [calcEqArr+bx], ax
	mov ax, 10
	mul Multyplayer
	mov Multyplayer, ax
	dec si
	jmp movToDifArr
ThereIsPeola1:
	xor ax, ax
	sub bx, 2
	mov al, [tempEq+si]
	mov [calcEqArr+bx], ax
	sub bx, 2
	dec si
	mov ax, 1
	mov Multyplayer, ax
	jmp movToDifArr
CalcNewEq:
	cmp bx, 4 ;If its is 4, there is 1 peolot, if 0 there is 2 peolot
	je OnePeolot
	cmp [calcEqArr+bx+2], '+'
	jne ChackMinus
	;plus stuff
	mov ax, [calcEqArr] ;first num
	mov cx, [calcEqArr+4] ;second num
	add ax, cx
	mov [calcEqArr+4], ax ;mov [calcEqArr+4] the result
	jmp OnePeolot
ChackMinus:
	cmp [calcEqArr+bx+2], '-'
	jne ChackMult
	;minus stuff
	mov ax, [calcEqArr] ;first num
	mov cx, [calcEqArr+4] ;second num
	sub ax, cx
	mov [calcEqArr+4], ax ;mov [calcEqArr+4] the result
	jmp OnePeolot
ChackMult:
	cmp [calcEqArr+bx+2], '*'
	jne IsDiv
	;mult stuff
	mov ax, [calcEqArr] ;first num
	mov cx, [calcEqArr+4] ;second num
	mul cx
	mov [calcEqArr+4], ax ;mov [calcEqArr+4] the result
	jmp OnePeolot
IsDiv:
	;div stuff
	mov ax, [calcEqArr] ;first num
	mov cx, [calcEqArr+4] ;second num
	div cx
	mov [calcEqArr+4], ax ;mov [calcEqArr+4] the result
	
	
OnePeolot: ;only one math peola

	mov bx, 4
	cmp [calcEqArr+bx+2], '+'
	jne ChackMinusB
	;plus stuff
	mov ax, [calcEqArr+bx] ;first num
	mov cx, [calcEqArr+4+bx] ;second num
	add ax, cx
	mov [calcEqArr+4+bx], ax ;mov [calcEqArr+4] the result
	jmp CMPResult
ChackMinusB:
	cmp [calcEqArr+bx+2], '-'
	jne ChackMultB
	;minus stuff
	mov ax, [calcEqArr+bx] ;first num
	mov cx, [calcEqArr+bx+4] ;second num
	sub ax, cx
	mov [calcEqArr+4+bx], ax ;mov [calcEqArr+4] the result
	jmp CMPResult
ChackMultB:
	cmp [calcEqArr+bx+2], '*'
	jne IsDivB
	;mult stuff
	mov ax, [calcEqArr+bx] ;first num
	mov cx, [calcEqArr+bx+4] ;second num
	mul cx
	mov [calcEqArr+bx+4], ax ;mov [calcEqArr+4] the result
	jmp CMPResult
IsDivB:
	;div stuff
	mov ax, [calcEqArr+bx] ;first num
	mov cx, [calcEqArr+bx+4] ;second num
	div cx
	mov [calcEqArr+bx+4], ax ;mov [calcEqArr+4] the result
	

CMPResult:
	xor bx,bx
	mov Multyplayer,1
	mov si,7
calcAnswer:
	xor ax, ax
	mov al,[tempEq+si]
	mul Multyplayer
	add bx,ax
	mov ax, 10
	mul Multyplayer
	mov Multyplayer, ax
	
	dec si
	cmp [tempEq+si],'='   ;dx is the location of =
	jne calcAnswer
	
	cmp bx,[calcEqArr+8]
	jne invalideEq

valideEq:

	cmp [currentBoxOutput],40
	je endProgram1
	jmp dontEndProgram1
endProgram1:
mov [endProgram],1

dontEndProgram1:

	call checkEqplacement
	jmp procExit4
invalideEq:
	mov cx,8
deleteRow2:
	dec [currentBoxOutput]
	push 'L' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	dec [currentBoxOutput]
	loop deleteRow2

procExit4:

add sp, 2
pop bp
ret 
endp calcEq

proc checkEqplacement     ; check the placement for the Inputed Eq and send the colors to the print box proc

	mov di,0
CheckWrongPlace1:
	mov si,0
CheckWrongPlace2:

	mov al,[tempEq+di]
	cmp al,[TheWinningEq+si]
	je WrongPlace
	
WrongPlaceExit:
	inc si
	cmp si,8
	jne CheckWrongPlace2

	
	inc di
	cmp di,8
	jne CheckWrongPlace1

jmp preCheckSamePlace
WrongPlace:
	
	mov [TempCheckForPlace+di], 1
	jmp WrongPlaceExit

preCheckSamePlace:
mov si,0
CheckSamePlace:
	xor al,al
	mov al,[tempEq+si]
	cmp al ,[TheWinningEq+si]
	je samePlace
	
CheckSamePlaceExit:
	inc si
	cmp si,8
	jne CheckSamePlace
	
	jmp EqExit
	
samePlace:
	mov [TempCheckForPlace+si], 2
	inc [counterWinning]
	jmp CheckSamePlaceExit


EqExit:
mov cx,7
deleteRow1:  
	dec [currentBoxOutput]
	push 'L' ;which num to print
	push [colorOutput] ; color
	call PrintBoxOutput
	dec [currentBoxOutput]
	loop deleteRow1



dec [currentBoxOutput]
mov si,0
PrintTheColors:
xor ax,ax
	mov al,[tempEq+si]
		mov di,0
		checkForPeola:
			cmp al,[arrPeola+di]
			je moveTextToAl
		inc di
		cmp di,6
		jne checkForPeola
ascicodeFix:
		add al,'0'
	moveTextToAl:
	cmp al,0
	je ascicodeFix
	cmp [TempCheckForPlace+si],0
	je WrongInputPrint
	cmp [TempCheckForPlace+si],1
	je WrongPlacePrint

rightPlacePrint:

	push ax ;which num to print
	push [colorCorrectPlace] ; color
	call PrintBoxOutput
	jmp PrintTheColorsExit
	
WrongInputPrint:

	push ax ;which num to print
	push [ColorNOnum] ; color
	call PrintBoxOutput
	jmp PrintTheColorsExit
	
WrongPlacePrint:

	push ax ;which num to print
	push [colorPlaceNO] ; color
	call PrintBoxOutput
	jmp PrintTheColorsExit
	
PrintTheColorsExit:

	inc si
	cmp si,8
	jne PrintTheColors
	jmp ProcExitEqPlace


ProcExitEqPlace:
mov si,0
clearEq:
mov [TempCheckForPlace+si],0
inc si
cmp si,8
jne clearEq
cmp [counterWinning],8
je WINNER1
jmp notwinner
WINNER1:

mov [endProgram],1
ret

notwinner:
mov [counterWinning],0

ret 
endp checkEqplacement	

proc DoDelay
    ;Wait [TicksToWait] Ticks. Tick is 55 miliseconds.
        push bp
        mov bp, sp
        TicksToWait equ [bp+4]
        push ax
        push bx
        push cx
        push dx
        mov cx, TicksToWait
            WaitTick:
                mov ax, 40h
                mov es, ax
                mov bl, [es:6Ch]
                    CheckForChange:
                        cmp bl, [es:6Ch]
                    je CheckForChange
            loop WaitTick
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret 2
endp DoDelay
	
	
proc RandomEq 
	;Recives the number to random (generates a number between 0 and the number) and generates a random number in that area. the number can be 1, 3, 7, 15, 31, 63, 127, 255.
    push bp
    mov bp, sp
    push ax
	push bx
    push cx
    push dx
    next equ [bp+4]
    ;======================
    ;move miliseconds to ax
    ;======================
    mov ax, 40h
    mov es, ax
    mov ax, [es:6Ch]
    ;================================================================================================
    ;set var randomNumber as a number in the range 0-(next-1). Same output as rnd.Next(0,next) in C#.
    ;================================================================================================
    and al, next 
	inc al
    mov [randomNumber], al
	
	xor ax,ax 
	mov al,8    
	mul [randomNumber]   ;mul the random number with 8 to get the offset of the selected arr
	mov si,ax
	mov bx,8
	ChangeWinArr:  
		mov al,[Eq1+si]     ;move the num/peola from the selected arr
		mov [TheWinningEq+bx],al   ;mov the num/peola to the winning arr
		dec si
	dec bx
	cmp bx,0FFFFh
	jne ChangeWinArr
	
exitRandom:
	pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 2

endp RandomEq
	
	
	start:
	mov ax, @data
	mov ds, ax

	; --------------------------
	; Your code here
	; --------------------------
	;Move to grafics Mode
	mov ax, 13h
	int 10h
	
	call Game_Starter   ;print the start menu and the rules
startAgain:
	mov ax, 13h
	int 10h
	call The_Great_Reset ;proc that resets vars and does random for new eq
	call PrintBackGround ;print the black background
	call PrintOutPutBoard ;print the boxed for the output
	call PrintInputRow1  ;print the boxes and text for row 1 input
	call PrintInputRow2  ;print the boxes and text for row 2 input
 
	
Mouse:    
	call MouseInput    ;check for keypress and call other proc accordly 
	push 4
	call DoDelay   ;wait a delay do prevent double key press
	mov ax, 1h
	int 33h;show mouse
	cmp [endProgram],1  ;check if the user have more tries
	jne mouse
	cmp [counterWinning],8  ;check if the user won
	je WINNER
	jmp loser

start1:
jmp startAgain

WINNER:

	mov ax,2 ;disable mouse
	int 33h
	
	push 20 ;add delay so you can see the result
	call DoDelay

	call PrintBackGround ;clear the screen to black
	mov  dl, 16   ;Column ---till 39
    mov  dh, 4   ;Row ---till 24
    xor bh, bh    ;Display page
    mov  ah, 02h  ;SetCursorPosition
    int  10h
    mov ah, 9h
    mov dx, offset VictoryText  ;print the text
    int 21h
	
looperW:     ;wait for key press, y to start again n to end the programm
	mov ah, 0ch
	int 21h
	mov ah, 1
	xor bl, bl
	int 21h
	cmp al, 'y'
	je start1
	cmp al, 'n'
	je exit
	jmp looperW

Loser:
	mov ax,2    ;disable mouse
	int 33h
	
	push 20     ;add delay so you can see the result
	call DoDelay
	
	call PrintBackGround       ;clear the screen to black
	mov  dl, 16   ;Column ---till 39
    mov  dh, 4   ;Row ---till 24
    xor bh, bh    ;Display page
    mov  ah, 02h  ;SetCursorPosition
    int  10h
    mov ah, 9h
    mov dx, offset LoserText   ;print the text
    int 21h
	
looperL:  ;wait for key press, y to start again n to end the programm
	mov ah, 0ch
	int 21h
	mov ah, 0ch
	int 21h
	mov ah, 1
	xor bl, bl
	int 21h
	cmp al, 'y'
	je start1
	cmp al, 'n'
	je exit
	jmp looperL
	
exit:

	mov ax, 4c00h
	int 21h
END start
