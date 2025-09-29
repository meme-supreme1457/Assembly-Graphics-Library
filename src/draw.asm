global _start

section .data
primary_color DB 0
secondary_color DB 0
is_drawing_wrapped DB 0
canvas_len DW 0
canvas_height DW 0


section .text
START:  ; The beginning 
call initialize ; initialize program
push word 1
push word 1
call put_pixel
add esp, 4

push word 2
push word 2
call put_pixel
add esp, 4

push word 3
push word 3
call put_pixel
add esp, 4

push word 4
push word 4
call put_pixel
add esp, 4

push word 5
push word 5
call put_pixel
add esp, 4

push word 6
push word 6
call put_pixel
add esp, 4

push word 7
push word 7
call put_pixel
add esp, 4

push word 8
push word 8
call put_pixel
add esp, 4

push word 9
push word 9
call put_pixel
add esp, 4

push word 10
push word 10
call put_pixel
add esp, 4

call clean_up ; return to DOS textmode


put_pixel:
push ebp     ; Save the old base pointer value.
mov ebp, esp ; Set the new base pointer value.
push ebx
xor eax,eax
xor ebx,ebx

mov ax, [ebp+6]
mov bx, [ebp+8]


mul word [canvas_len]
add ax,bx
mov di,ax
mov dl,15
mov [es:di],dl

; Subroutine Epilogue 
pop ebx
mov esp, ebp ; Deallocate local variables
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