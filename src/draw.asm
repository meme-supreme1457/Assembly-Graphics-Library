section .data
primary_color DB 15
secondary_color DB 15
is_drawing_wrapped DB 0
value_store_1 DW ?
value_store_2 DW ?
canvas_len DW 320
canvas_height DW 200


section .text
START:
call initialize ; initialize program
push 1
push 1
call put_pixel
push 2
push 2
push 3
push 3
call put_pixel
call put_pixel
push 4
push 4
push 5
push 5
call put_pixel
call put_pixel
push 6
push 6
push 7
push 7
push 8
push 8
call put_pixel
call put_pixel
call put_pixel
push 9
push 9
push 10
push 10
call put_pixel
call put_pixel
call clean_up ; return to DOS textmode


put_pixel:
pop bx
pop ax
cmp [is_drawing_wrapped],0 ; check if wrap mode is enabled
je non_wrap_check_x ; jump to non-wrapping bounds checking if wrap mode is disabled
jmp wrap_check_x ; else jump to wrapping bounds checking

non_wrap_check_x:
cmp [canvas_len], bx
jle non_wrap_check_y ; if x is in bounds jump to checking y
ret ; if x is out of bounds, return from function

non_wrap_check_y:
cmp [canvas_height], ax
jle wrap_check_done ; if y is in bounds jump to drawing
ret ; if y is out of bounds, return from function

wrap_check_x: 
cmp [canvas_len], bx
jle wrap_check_y ; if x is in bounds jump to checking y
sub bx, [canvas_len] ; else subtract length to get back in bounds

wrap_check_y:
cmp [canvas_height], ax
jle wrap_check_done ; if y is in bounds jump to drawing
sub ax, [canvas_height] ; else subtract height to get back in bounds

wrap_check_done: ; now that bounds checking is done, drawing the pixel can begin
mul [canvas_len] ; multiply the accumulator by the canvas length to get the y offset into the array
add ax,bx ; add the x value to the accumulator to get the positional offset into the array
mov [es:di],[primary_color]
ret





initialize: ; Set mode 13h
mov ah,0
mov al,13h
int 10h
mov ax,0A000h
mov es,ax
ret


clean_up: ; Restore textmode for DOS
mov ah,0  
mov al,3 
int 10h  
