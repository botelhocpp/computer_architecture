[BITS 64]

EXTERN strlen
EXTERN strcpy
EXTERN strcmp
EXTERN scanf
EXTERN printf
EXTERN malloc
EXTERN free

%INCLUDE "palindromeASM.inc"

; Local variable identifiers.
%DEFINE BUFFER  [RBP - 1024]
%DEFINE INPUT   [RBP - 1032]

SECTION .rodata
L1 DB "%s", 0
L2 DB "%d", 10, 0

SECTION .text
GLOBAL main
main:
	PUSH RBP
	MOV RBP, RSP

	; Defines 1024 bytes for a buffer.
	; Defines 8 bytes for the string pointer.
	SUB RSP, 1040	

	; Gets the string from the user.
	LEA RSI, BUFFER
	LEA RDI, [L1]
	CALL scanf

	; Gets the size of the string. 
	LEA RSI, BUFFER
	CALL strlen	

	; Allocates a string of the size of
	; the input string. 
	MOV RDI, RAX
	CALL malloc
	
	; Copy the input, in the buffer, to
	; the final allocated memory space.
	MOV INPUT, RAX
	MOV RDI, RAX
	LEA RSI, BUFFER
	CALL strcpy

	; Checks if the string is, or not, a
	; palindrome.
	MOV RDI, INPUT
	CALL isPalindrome

	; Print the result:
	; 0 for FALSE
	; 1 for TRUE
	MOV RSI, RAX
	LEA RDI, [L2]
	CALL printf 

	; Free the allocated memory.
	MOV RDI, INPUT
	CALL free

	MOV RSP, RBP
	POP RBP
	XOR EAX, EAX
	RET