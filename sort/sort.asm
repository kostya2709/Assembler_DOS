.model tiny
.data
array dw 4, 3, 2, 1
size dw 4
new_array dw 10 dup (?)
.code
locals @@
org 100h

Start:

		lea si, new_array
		call Read_CMD

		lea di, new_array
		call sort

		mov ax, 4c00h
		int 21h

;-----------------------------SORT---------------------------
; This function sort an array using bubble sort.
;	Input: 
;		CX - number of elements
;		DI - pointer to the array
;	Destr:
;		AX, BX, DX
;------------------------------------------------------------

				sort proc

				sub cx, 1
				mov dx, 0
				
				@@Cycle1:
				mov bx, di
				mov ax, di
				add ax, cx
				add ax, cx 
					@@Cycle2:
					mov dx, word ptr es:[bx]
					cmp dx, word ptr es:[bx+2]
					jbe @@next
					mov dx, word ptr es:[bx+2]
					push ax
					mov ax, word ptr es:[bx]
					mov word ptr es:[bx], dx
					mov word ptr es:[bx+2], ax
					pop ax
					@@next:
					add bx, 2
					cmp bx, ax
					jb @@Cycle2
				
				loop @@Cycle1

				ret
				endp

;---------------------------READ_CMD-------------------------------
; Reads numbers from CMD.
;	Input: 
;		SI - pointer to the string where to write elements to.
;	Destr:
;		AX, BX, DX, DI
;	Output:
;		CX - number of elements
;------------------------------------------------------------------

		Read_CMD proc

		xor cx, cx
		mov cl, byte ptr ds:[80h]		;num of command line args
		sub cx, 1

		push 0
		xor bx, bx
		mov di, 82h

		@@Cycle:

		cmp byte ptr [di], 20h
		je @@End_Num
		mov ax, 10d
		mul bx
		mov bx, ax
		mov byte ptr al, [di]
		sub ax, 30h
		add bx, ax
		inc di
		cmp cx, 1
		je @@End_Num
		jmp @@ToLoop
		
		@@End_Num:
		mov word ptr cs:[si], bx
		add si, 2
		inc di
		pop ax
		inc ax
		push ax
		xor bx, bx
		cmp cx, 1
		je @@End
		@@ToLoop:
		loop @@Cycle
		@@End:

		pop cx

		ret
		endp

end Start