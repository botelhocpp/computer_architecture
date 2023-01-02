; File: 		main.asm
; Author: 	Pedro Botelho
; Description:	Takes a float, representing the point of the sine function to
;			calculate, as well as the number of terms that approximate the 
;			taylor expansion (an unsigned integer), and calculates the result
;			of the sine function in x using "taylor series" (in AVX2).
; Date: 		30/DEZ/2022

[BITS 64]

%INCLUDE "stdio.inc"
%INCLUDE "taylorseries.inc"

%DEFINE X_VALUE          [RBP - 16]  ; float
%DEFINE TERMS_NUMBER     [RBP - 12]  ; int
%DEFINE SERIES_RESULT    [RBP - 8]   ; double

SECTION .rodata
strGetParameters 	DB "%f%d", 0x0
strSinPutResult    	DB "sin(x) at x = %lf, with %d therms, is: %lf", 0x0A, 0x00

SECTION .text
GLOBAL main
main:
	PUSH RBP
	MOV RBP, RSP
	SUB RSP, 16
	
	LEA RDI, [strGetParameters] 
	LEA RSI, X_VALUE
	LEA RDX, TERMS_NUMBER
	XOR EAX, EAX
	CALL scanf

	VCVTSS2SD XMM0, X_VALUE
	MOV EDI, TERMS_NUMBER
	CALL sinTaylorSeries
	VMOVSD SERIES_RESULT, XMM0

	LEA RDI, [strSinPutResult]
	VCVTSS2SD XMM0, X_VALUE
     MOV RSI, TERMS_NUMBER
	VMOVSD XMM1, SERIES_RESULT
	MOV EAX, 2
	CALL printf

	MOV RSP, RBP
	POP RBP
	XOR EAX, EAX
	RET
     