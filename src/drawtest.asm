

section .data
primary_color DB 0
secondary_color DB 0
is_drawing_wrapped DB 0
canvas_len DW 0
canvas_height DW 0


section .text

;global start
global initialize
global put_pixel
global clean_up
global draw_line

start:

call initialize ; initialize program

push 2
push 2
push 6
push 6
call draw_line
add esp, 8
call clean_up


draw_line:

; Subroutine Prologue 
push ebp ; Save the old base pointer value.
mov ebp, esp ; Set the new base pointer value.
sub esp, 4; Make room for two 2-byte local variables and one 4-byte local variable
push ebx
xor ebx,ebx
xor eax,eax



mov cx, [ebp+10]
sub cx, [ebp+6] ;cx register stores delta-x


mov ax, [ebp+12]
sub ax, [ebp+8] ;ax register stores delta-y


div cx ;ax stores slope
mov bx, [ebp+6] ; bx stores x1

line_loop_start:
    cmp bx,[ebp+10]
    jg line_epilogue ;while !(bx > x2)
    ;mov [ebp-8], esp ; save esp
    mov [ebp-2], ax ; save value of ax
    mov [ebp-4], bx ; save value of bx
    
    ;push bx
    ;push word [ebp+8]
    ;call put_pixel
   
    mov ax, bx
    mul word [canvas_len]
    add ax,[ebp+8]
    mov di,ax
    mov dl,15
    mov [es:di],dl
   
    xor eax,eax
    xor ebx,ebx
    mov ax, [ebp-2] ;restore ax
    mov bx, [ebp-4] ;restore bx

    add [ebp+8], ax ; add slope to y value
    inc bx ; increment x value
jmp line_loop_start

line_epilogue:
pop ebx
mov esp, ebp
pop ebp
ret


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