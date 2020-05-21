.model tiny
.code
org 100h

Start:
jmp next
File_Name: db "W:\ASM_PROG\KEY_LOGE\passwors.txt", 0

next:

		mov ah, 3ch
		mov cx, 02d
		mov dx, offset File_Name
		int 21h




mov ax, 4c00h
int 21h

end Start