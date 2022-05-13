[BITS 64]

EXTERN strlen

SECTION .text

;int isPalindrome(char *str);
GLOBAL isPalindrome
isPalindrome:
	PUSH RBP
	MOV RBP, RSP

	; Put the string size in R8.
	PUSH RDI
	CALL strlen
	MOV R8, RAX
	POP RDI

	; R9D as 0 (j)
	XOR R9D, R9D     
	
	; R10 as size - 1 (i)
 	MOV R10, RAX
	DEC R10

	; RAX as size/2
	MOV RBX, 2
	MOV RDX, 0
	DIV RBX

	.while:
		CMP R10, RAX
		Jl .returnTrue
		MOV BL, [RDI + R10]
		MOV DL, [RDI + R9]
		CMP BL, DL
		Jne .returnFalse
		INC R9
		DEC R10
     	JMP .while

	.returnTrue:
		MOV RAX, 1	

	.exit:	
	MOV RSP, RBP
	POP RBP
	RET

	.returnFalse:
		MOV RAX, 0
		JMP .exit
