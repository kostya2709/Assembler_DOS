.model tiny																																																																																																																																																			
locals @@								
.code
.186
extrn strlen:proc

public Draw_Pixel
public Printf
public Draw_Column
public Draw_Line
public Draw_Rect
public Draw_Shadow_Rect
public Draw_Frame

;+++++++++++++++++++++++++++++++++++ DRAW_PIXEL +++++++++++++++++++++++++++++++
;	Draws a point in (x, y). Inserts symbols with particular color.
;		Entry:	
;				ES - video memory
;				AL - symbol
;				AH - color
;				BL - start_x
;				BH - start_y
;		Destr:  DX, DI
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		Draw_Pixel proc

		push ax bx si
		mov si, bx
		and si, 255
		mov bl, 0d
		shr bx, 8
		mov ax, 80d
		mul bx
		add ax, si
		shl ax, 1
		mov di, ax
		pop si bx ax

		stosw

		ret
		endp

;+++++++++++++++++++++++++++++++++++ DRAW_COLUMN +++++++++++++++++++++++++++++++
;	Draws a vertical line between points (start_x, start_y), (start_x, ;start_y + height). Inserts symbols with particular color.
;		Entry:	
;				ES - video memory
;				AL - symbol
;				AH - color
;				BL - start_x
;				BH - start_y
;				CH - height
;		Destr:  CX, DX, DI
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		Draw_Column proc

		push ax bx bx
		mov ax, 80
		shr bx, 8
		mul bx
		pop bx
		and bx, 255
		add ax, bx
		shl ax, 1
		mov di, ax 
		pop bx ax

		shr cx, 8

		@@Cycle:
		stosw
		add di, 158
		loop @@Cycle

		ret
		endp

;+++++++++++++++++++++++++++++++++++ DRAW_LINE +++++++++++++++++++++++++++++++
;	Draws a horizontal line between points (start_x, start_y), (start_x + length, ;start_y). Inserts symbols with particular color. If symbol = 0 symbol is not changed.
;		Entry:	
;				ES - video memory
;				AL - symbol
;				AH - color
;				BL - start_x
;				BH - start_y
;				CL - length
;		Destr:  DX, DI, CX
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		Draw_Line proc

		cld

		push ax bx bx
		mov ax, 80
		shr bx, 8
		mul bx
		pop bx
		and bx, 255
		add ax, bx
		shl ax, 1
		mov di, ax 
		pop bx ax

		cmp al, -1
		je No_Sym

		rep stosw
		jmp Exit

		No_Sym:
		inc di
		@@Cycle:
		mov byte ptr es:[di], ah
		add di, 2
		loop @@Cycle


		Exit:
			ret
			endp

;+++++++++++++++++++++++++++++++++++ Draw_Rect +++++++++++++++++++++++++++++++
;	Draws a rectangle with left top point (start_x, start_y) with width and height. Inserts symbols with particular color. If symbol = 0 symbol is not changed.
;		Entry:	
;				ES - video memory
;				AL - symbol
;				AH - color
;				BL - start_x
;				BH - start_y
;				CL - length
;				CH - height
;		Destr:  DX, DI, BH
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		Draw_Rect proc


		mov dx, cx
		mov ch, 0

		@@Cycle:

		cmp dh, 0
		je @@Exit
		push dx
		call Draw_Line
		pop dx
		mov cl, dl
		inc bh
		dec dh
		jmp @@Cycle

		@@Exit:

		ret
		endp


;++++++++++++++++++++++++++++++++++++++++PRINTF+++++++++++++++++++++++++++++++++
;	Draws a message in point (start_x, start_y). Inserts symbols with a particular ;color. 
;		Entry:	
;				ES - video memory
;				AL - color
;				BL - start_x
;				BH - start_y
;				SI - pointer to the text
;		Destr:  DX, DI, BX, SI
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		Printf proc

			mov dx, ax
			mov al, 80
			mul bh
			add al, bl
			shl ax, 1
			mov di, ax  
			mov ax, dx

		push di si
		xor bx, bx
		@@Cycle:
		mov bx, ds:[si]
		cmp bl, 0
		je @@Exit
		movsb
		mov byte ptr es:[di], al
		inc di
		jmp @@Cycle

		@@Exit:
		pop si di
		ret
		endp

;+++++++++++++++++++++++++++++++++++ Draw_Shadow_Rect +++++++++++++++++++++++++++++++
;	Draws a rectangle with shadow with left top point (start_x, start_y) with width and height. Inserts symbols with particular color. If symbol = 0 symbol is not changed.
;		Entry:	
;				ES - video memory
;				AL - symbol
;				AH - color
;				BL - start_x
;				BH - start_y
;				CL - length
;				CH - height
;				SI - pointer to the title
;				BP - pointer to the text
;		Destr:  AX, BX, CX, DX, DI
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
		Tittle_Size dw ? 
		Text_Size dw ?
		
		Draw_Shadow_Rect proc


			push ax bx cx
			mov ah, 70h
			mov al, -1
			add bl, 2
			inc bh
			call Draw_Rect
			pop cx bx ax

			push cx bx
			call Draw_Rect
			pop bx cx

			mov al, 0cdh		;Top Line
			push cx
			mov ch, 0
			push bx
			call Draw_Line
			pop bx
			pop cx

			push cx				;Bottom Line
			push bx
			add bh, ch
			dec bh
			xor ch, ch
			call Draw_Line
			pop bx
			pop cx

		    mov al, 0bah		;Left Column
			push cx
			push bx
			call Draw_Column
			pop bx
			pop cx

			push cx				;Right Column
			push bx
			add bl, cl
			dec bl
			call Draw_Column
			pop bx
			pop cx

			push dx ax bx bx 			;print title
			mov dx, ax
			mov di, si
			call strlen
			pop bx
			push cx
			sub cl, al
			shr cl, 1
			add bl, cl
			mov ax, dx
			shr ax, 8
			push si
			call Printf
			pop si cx bx ax dx

			push dx ax bx bx 			;print text
			mov dx, ax
			mov di, bp
			call strlen
			pop bx
			push cx
			sub cl, al
			shr cl, 1
			add bl, cl

			shr ch, 1
			add bh, ch
			mov ax, dx
			shr ax, 8
			push si
			mov si, bp
			call Printf
			pop si cx bx ax dx

			mov al, 0c9h		;Top left angle
			call Draw_Pixel

			mov al, 0bbh		;Top right angle
			add bl, cl
			dec bl
			call Draw_Pixel
			inc bl
			sub bl, cl

			mov al, 0c8h		;Bottom left angle
			add bh, ch
			dec bh
			call Draw_Pixel
			inc bh
			sub bh, ch


			mov al, 0bch		;Bottom right angle
			add bl, cl
			dec bl
			add bh, ch
			sub bh, 1
			call Draw_Pixel
			inc bh
			sub bh, ch
			inc bl
			sub bl, cl

		ret
		endp

;+++++++++++++++++++++++++++++++++++DRAW_FRAME+++++++++++++++++++++++++++++++
;	Draws a rectangle with shadow with left top point (start_x, start_y) with width and height. Inserts symbols with particular color. If symbol = 0 symbol is not changed.
;		Entry:	
;				ES - video memory
;				AL - symbol
;				AH - color
;				BL - start_x
;				BH - start_y
;				CL - length
;				CH - height
;				SI - pointer to the title
;				BP - pointer to the text
;		Destr:  DX, DI
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

		Draw_Frame proc

		mov dx, 6
		@@Cycle:
		push ax bx cx dx
		call Draw_Shadow_Rect
		pop dx cx bx ax


		sub bl, 2
		sub bh, 1
		add cl, 4
		add ch, 2

		push ax cx dx
		mov ah, 86h
		mov cx, 1
		mov dx, 8000h
		int 15h
		pop dx cx ax

		dec dx

		cmp dx, 0
		ja @@Cycle

		ret
		endp


end