IDEAL
MODEL small
STACK 100h
DATASEG
; --------------------------
Xpos dw 64h ;X position
Ypos dw 64h ;Y position
DrawWidth dw 15
; --------------------------
CODESEG
;
proc ResetPixel ;Reseting pixels from screen
mov ah,00 
int 16h 
cmp al,72h ;Checking if r is pressed
je Reset
ret
endp ResetPixel

proc DrawPixel ;Draws pixel
mov ah,8h
mov bh,0
mov bl,0
int 10h

mov cx,[Xpos]
mov dx,[Ypos]
mov ah,0ch
mov al,15
int 10h
ret
endp DrawPixel

proc DrawLine
mov ah,00 
int 16h 
cmp al, 108 ;Checking if l is pressed
je Line
ret
endp DrawLine

proc MoveRight
inc [Xpos]
call DrawPixel
ret 
endp MoveRight

proc MoveLeft
dec [Xpos]
call DrawPixel
ret
endp MoveLeft

proc MoveUp
inc [Ypos]
call DrawPixel
ret
endp MoveUp

proc MoveDown
dec [Ypos]
call DrawPixel
ret
endp MoveDown
;
start:
    mov ax, @data
    mov ds, ax
; --------------------------
Reset:
mov ah,00h
mov al,13h
int 10h
call DrawPixel
jmp startingPoint

Line:
push [xPos] ;save Xpos to stack, to allow us to restore it's value
mov cx, [DrawWidth] ;set loop to run drawWidth times
LineLoop:
push cx ;save cx value, since it will change during DrawPixel
call DrawPixel ;draw pixel in loop
inc [Xpos]
pop cx ;restore cx value, along with line 35
loop LineLoop
pop [Xpos] ;restore Xpos value, along with line 32
jmp startingPoint

CallRight:
call MoveRight
jmp startingPoint

CallLeft:
call MoveLeft
jmp startingPoint

CallDown:
call MoveDown
jmp startingPoint

CallUp:
call MoveUp
jmp startingPoint

startingPoint:
call DrawLine ;Checking if l is pressed and if it is draw a line

mov ah, 00
int 16h
cmp al, 64h ;Checking if d is pressed
je CallRight

call ResetPixel ;Checking if r is pressed and if it is then reset
call DrawLine ;Checking if l is pressed and if it is draw a line

mov ah, 00
int 16h
cmp al,61h ;Checking if a is pressed
je CallLeft

call ResetPixel ;Checking if r is pressed and if it is then reset
call DrawLine ;Checking if l is pressed and if it is draw a line

mov ah, 00
int 16h
cmp al, 77h ;Checking if w is pressed
je CallDown

call ResetPixel ;Checking if r is pressed and if it is then reset
call DrawLine ;Checking if l is pressed and if it is draw a line

mov ah, 00
int 16h
cmp al, 73h ;Checking if s is pressed
je CallUp

call ResetPixel ;Checking if r is pressed and if it is then reset
call DrawLine ;Checking if l is pressed and if it is draw a line

jmp StartingPoint
; --------------------------  
exit:
    mov ax, 4c00h
    int 21h
END start
