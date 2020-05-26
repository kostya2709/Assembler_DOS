.model tiny
.code
.186
locals @@

public memchr, memset, memcmp, memcpy
public strchr, strlen, strcmp, strcpy

Text1: db "Hello", 0
Text2: db "Hello", 0

COMMENT *
;-----------------------------MEMCHR-----------------------
;The program finds the first appearance of the symbol not far
;than in maximal number of bytes from the pointer
;
;		Entry:	ES - segment with a string
;				DI - pointer to the string in the segment
;				AL - char to find
;				CX - maximal number of bytes 
;		
;		Return value:
; Returns value in AX: a pointer to the location of the character,
; or NULL if no such character is found.
;
;-----------------------------------------------------------
*

memchr proc

		cld

		repne scasb
		jne NEQU
		mov ax, di
		sub ax, 1
		jmp @@Exit

		NEQU:
		mov ax, 0

@@Exit:

ret
endp

;-----------------------------STRLEN------------------------------
;The program returns the length of the string up to symbol '\0'
;
;		Entry:	DS - segment with a string
;				DI - pointer to the string in the segment
;		
;		Return value:
; Returns value in AX: length of the string
;
;-----------------------------------------------------------------

strlen proc

		push di
		mov ax, 0
@@Cycle:
		cmp byte ptr ds:[di], 0
		je @@End
		inc di
		inc ax
		jmp @@Cycle

@@End:
		pop di
		ret
endp
;-------------------------------------------------------------------

;-----------------------------STRCHR-----------------------
;The program finds the first appearance of the symbol before
;terminating symbol of the string ('\0').
;
;		Entry:	ES - segment with a string
;				DI - pointer to the string in the segment
;				AX - char to find
;		
;		Return value:
; Returns value in DI: a pointer to the location of the character,
; or NULL if no such character is found.
;
;-----------------------------------------------------------

strchr proc

@@Cycle:
		cmp cs:[di], ax
		je @@End
		cmp byte ptr cs:[di], 0
		je @@End1
		inc di
		jmp @@Cycle


@@End1:
		mov di, 0

@@End:
ret
endp
;-------------------------------------------------------------------------

;-----------------------------MEMCMP--------------------------------------
;The program compares two strings up to number of bytes, equal to CX value
;
;		Entry:	ES - segment with the first string
;				DI - pointer to the string in the segment
;				DS - segment with the second string
;				SI - pointer to the second string
;				CX - maximal number of bytes 
;		
;		Return value:
; Returns value in CX: value is equal zero if the strings are equal.
; Value is above zero if the first string is higher (lexicographically),
; and below zero if not.
;
;-------------------------------------------------------------------------
memcmp proc

		cld
		repe cmpsb

ret
endp
;--------------------------------------------------------------------------


;-----------------------------STRCMP--------------------------------------
;The program compares two strings up to '\0' symbol.
;
;		Entry:		ES - segment with the first string
;				DI - pointer to the string in the segment
;				DS - segment with the second string
;				SI - pointer to the second string
;		
;		Return value:   AX - result
; Returns value in AX: value is equal zero if the strings are equal.
; Value is above zero if the first string is higher (lexicographically),
; and below zero if not.
;
;-------------------------------------------------------------------------
strcmp proc

cld
		mov ax, 0
@@Cycle:
		cmp byte ptr ds:[si], 0
		je @End
		cmpsb
		je @@Cycle
		jmp @@Not_equal

@@Not_equal:
		mov ax, es:[di-1]
		sub ax, ds:[si-1]
		sub ax, es:[di]
@@End:
		add ax, es:[di]
ret
endp
;--------------------------------------------------------------------------
;-----------------------------MEMSET--------------------------------------
;The program inserts number of symbols from AX to the pointer.
;
;		Entry:	ES - segment with the string
;				DI - pointer to the string in the segment
;				AL - symbol to insert
;				CX - number of symbols
;-------------------------------------------------------------------------
memset proc

		rep stosb

ret
endp

;-----------------------------MEMCPY--------------------------------------
;The program inserts number of symbols from DS:SI to ES:DI.
;
;		Entry:	DS - segment with the first string (source)
;				SI - pointer to the string in the segment (source)
;				ES - segment with the second string (destination)
;				DI - pointer to the string in the segment (destination)
;				CX - number of symbols
;-------------------------------------------------------------------------
memcpy proc

		rep movsb

ret
endp

;-----------------------------STRCPY--------------------------------------
;The program inserts number of symbols from DS:SI to ES:DI until source
;symbol is equal '\0'.
;
;		Entry:	DS - segment with the first string (source)
;				SI - pointer to the string in the segment (source)
;				ES - segment with the second string (destination)
;				DI - pointer to the string in the segment (destination)
;-------------------------------------------------------------------------
strcpy proc

@@Cycle:
		cmp byte ptr ds:[si], 0
		je @End
		movsb
		jmp @@Cycle

@End:
ret
endp

end
