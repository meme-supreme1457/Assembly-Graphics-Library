global _start

section .data
primary_color DB 0
secondary_color DB 0
is_drawing_wrapped DB 0
canvas_len DW 0
canvas_height DW 0


section .text
START:  ; The beginning 
call initialize
push 4
push 4
call put_pixel
add esp, 4


call clean_up


put_pixel:
push ebp     ; Save the old base pointer value.
mov ebp, esp ; Set the new base pointer value.
push ebx     ; Save the values of registers that the function will modify. 

mov ax, [ebp+4]
mov bx, [ebp+6]

cmp word [is_drawing_wrapped],0 ; check if wrap mode is enabled
je non_wrap_check_x ; jump to non-wrapping bounds checking if wrap mode is disabled
jmp wrap_check_x ; else jump to wrapping bounds checking

non_wrap_check_x:
cmp [canvas_len], bx
jg non_wrap_check_y ; if x is in bounds jump to checking y
ret ; if x is out of bounds, return from function

non_wrap_check_y:
cmp [canvas_height], ax
jg wrap_check_done ; if y is in bounds jump to drawing
ret ; if y is out of bounds, return from function

wrap_check_x: 
cmp [canvas_len], bx
jg wrap_check_y ; if x is in bounds jump to checking y
sub bx, [canvas_len] ; else subtract length to get back in bounds

wrap_check_y:
cmp [canvas_height], ax
jg wrap_check_done ; if y is in bounds jump to drawing
sub ax, [canvas_height] ; else subtract height to get back in bounds

wrap_check_done: ; now that bounds checking is done, drawing the pixel can begin

mul word [canvas_len]
add ax,bx
mov di,ax
mov dl,7
mov [es:di],dl

; Subroutine Epilogue 
pop ebx      ; Recover register values
pop ebp ; Restore the caller's base pointer value

ret


initialize: ; Set mode 13h and initialize variables
mov ah,0
mov al,13h
int 10h
mov ax,0A000h
mov es,ax
mov word [canvas_height], 200
mov word [canvas_len], 320
mov byte [primary_color], 15
mov byte [secondary_color], 15
mov byte [is_drawing_wrapped], 0
ret


clean_up: ; Restore textmode for DOS
wl:             ; mark wl
mov ah,0        ; 0 - keyboard BIOS function to get keyboard scancode
int 16h         ; keyboard interrupt
jz wl           ; if 0 (no button pressed) jump to wl
mov ah,0  
mov al,3 
int 10h 
ret