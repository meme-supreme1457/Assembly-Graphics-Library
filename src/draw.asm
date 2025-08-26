.DATA
primary_color DB 15
secondary_color DB 15
is_drawing_wrapped DB 0
value_store_1 DW ?
value_store_2 DW ?



START:





INITIALIZE: ; Set mode 13h
mov ah,0
mov al,13h
int 10h
mov ax,0A000h
mov es,ax


CLEAN_UP: ; Restore textmode for DOS
mov ah,0  
mov al,3 
int 10h  