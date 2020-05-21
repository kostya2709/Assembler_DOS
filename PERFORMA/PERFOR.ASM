.model tiny																																																																																																																																																			
locals @@								
.code
.186
extrn Draw_Frame:proc
org 100h


Start:
jmp next

Tittle: db "DRAGON X", 0
Text: db "hellooo", 0

next:

	mov ax, GRAPHIC_PTR
	mov es, ax

	mov ax, offset Tittle
	mov si, ax
	mov ah, 4eh
	mov al, ' '
	mov cl, 20
	mov ch, 3
	mov bl, 40
	mov bh, 10
	lea bp, Text

	call Draw_Frame

	mov ax, 4c00h
	int 21h

;--------------------------------------DEFINES---------------------------------
X1	equ 20
XSH     equ 22
Y1 	equ 10
YSH	equ 11
WID	equ 50
HEIGHT 	equ  10
GRAPHIC_PTR equ 0b800h
LETTER_STYLE equ 204eh
LLENGTH 	equ 20
;--------------------------------------------------------------------------------

end	Start