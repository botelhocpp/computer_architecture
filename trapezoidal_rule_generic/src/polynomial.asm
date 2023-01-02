; ==============================================================================
; File: 	     polynomial.asm
; Author:      Pedro Botelho
; Description: Defines a function that represents a polynomial mathematical function.
; Date:        02/JAN/2023
; ==============================================================================

[BITS 64]

%INCLUDE "math.inc"

%DEFINE COEFFICIENTS 	RBP - 8
%DEFINE DEGREE 		RBP - 16
%DEFINE X_VALUE 		RBP - 24
%DEFINE ITERATOR 		RBP - 32
%DEFINE ACCUMULATOR 	RBP - 40

SECTION .text

; ==============================================================================
GLOBAL polynomialFunction
polynomialFunction:
; Description: Calculate the result of a polynomial function of given degree, at
;			a given point x.
; Prototypes:  double polynomialFunction(double *coefficients, unsigned int degree, double x);
; Parameters:  A pointer to the function coefficients, in RDI, the degree of the 
;			function, in RSI, and the point x of interest, in XMM0.
; Return:      The function result, p(x) at given x, in XMM0.
; ==============================================================================
	PUSH RBP
	MOV RBP, RSP
	SUB RSP, 64

	MOV [COEFFICIENTS], RDI
	MOV [DEGREE], RSI
	VMOVSD [X_VALUE], XMM0
	MOV QWORD[ITERATOR], 0
	MOV QWORD[ACCUMULATOR], 0

	.calculatingLoop:
		VMOVSD XMM0, [X_VALUE]
		MOV RDI, [ITERATOR]
		CALL power

		MOV RDI, [COEFFICIENTS]
		MOV RCX, [ITERATOR]
		VMULSD XMM0, [RDI + 8*RCX]

		VADDSD XMM0, [ACCUMULATOR]
		VMOVSD [ACCUMULATOR], XMM0

		INC RCX
		CMP RCX, [DEGREE]
		MOV [ITERATOR], RCX
		Jbe .calculatingLoop

	.calculatingEnd:
	MOV RSP, RBP
	POP RBP
	RET 
