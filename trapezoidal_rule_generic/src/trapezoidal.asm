; ==============================================================================
; File: 	     trapezoidal.asm
; Author:      Pedro Botelho
; Description: Defines a function that approximates the integral of a polynomial
;			function p(x) using the trapezoidal rule.
; Date:        02/JAN/2023
; ==============================================================================

[BITS 64]

%INCLUDE "polynomial.inc"

SECTION .rodata
denominator DQ 2.0

SECTION .text

%DEFINE COEFFICIENTS 	RBP - 8
%DEFINE DEGREE 		RBP - 16
%DEFINE PREVIOUS_X 		RBP - 24
%DEFINE CURRENT_X 		RBP - 32
%DEFINE N_INTERVALS 	RBP - 40
%DEFINE ITERATOR 		RBP - 48
%DEFINE ACCUMULATOR 	RBP - 56
%DEFINE STEP		 	RBP - 64
%DEFINE CURRENT_RESULT	RBP - 72

; ==============================================================================
GLOBAL trapezoidalApproximationPolynomial
trapezoidalApproximationPolynomial:
; Description: Approximates the integral of a polynomial function of degree n from
;			a to b using the trapezoidal rule. Subintervals are defined between
;			a and b, in order to approximate the integral.
; Prototypes:  double trapezoidalApproximation(double *coefficients, unsigned int degree, double a, double b, int subintervals);
; Parameters:  A pointer to the coefficients of the function (RDI), the degree of the
;			function (RSI), the limits a (in XMM0) and b (in XMM1), and the
;			sub-intervals in (RDX).
; Return:      The area under the curve p(x), approximated by the sum of trapezoids,
;			defined by the subintervals.
; ==============================================================================
	PUSH RBP
	MOV RBP, RSP
	SUB RSP, 72

	MOV [COEFFICIENTS], RDI
	MOV [DEGREE], RSI
	VMOVSD [CURRENT_X], XMM0 
	MOV QWORD[PREVIOUS_X], 0 
	MOV [N_INTERVALS], RDX
	MOV QWORD[ITERATOR], 1
	MOV QWORD[ACCUMULATOR], 0

	VSUBSD XMM2, XMM1, XMM0
	VCVTSI2SD XMM3, RDX
	VDIVSD XMM2, XMM3 
	VMOVSD [STEP], XMM2 
	
	CMP RDX, 0
	Jle .calculationEnd
	
	.calculationLoop:
		; Compute f(x_k-1)
		MOV RDI, [COEFFICIENTS]
		MOV RSI, [DEGREE]
		VMOVSD XMM0, [CURRENT_X]
		CALL polynomialFunction
		VMOVSD [CURRENT_RESULT], XMM0

		; Compute f(x_k)
		MOV RDI, [COEFFICIENTS]
		MOV RSI, [DEGREE]
		VMOVSD XMM0, [CURRENT_X]
		VMOVSD [PREVIOUS_X], XMM0
		VADDSD XMM0, [STEP]
		VMOVSD [CURRENT_X], XMM0
		CALL polynomialFunction
		VADDSD XMM0, [CURRENT_RESULT]

		; Compute delta_x_k/2
		VMOVSD XMM1, [CURRENT_X]
		VSUBSD XMM1, [PREVIOUS_X]
		VDIVSD XMM1, [denominator]
		VMULSD XMM0, XMM1

		VADDSD XMM0, [ACCUMULATOR]
		VMOVSD [ACCUMULATOR], XMM0

		MOV RCX, [ITERATOR]
		INC RCX
		MOV [ITERATOR], RCX
		CMP RCX, [N_INTERVALS]
		Jbe .calculationLoop

	.calculationEnd:
	MOV RSP, RBP
	POP RBP
	RET 

%DEFINE FUNCTION 		RBP - 8
%DEFINE PREVIOUS_X 		RBP - 16
%DEFINE CURRENT_X 		RBP - 24
%DEFINE N_INTERVALS 	RBP - 32
%DEFINE ITERATOR 		RBP - 40
%DEFINE ACCUMULATOR 	RBP - 48
%DEFINE STEP		 	RBP - 56
%DEFINE CURRENT_RESULT	RBP - 64

; ==============================================================================
GLOBAL trapezoidalApproximation
trapezoidalApproximation:
; Description: Approximates the integral of a given function f(x), from a to b using
;              the trapezoidal rule. Subintervals are defined between a and b,
;              in order to approximate the integral.
; Prototypes:  double trapezoidalApproximation(double (*function)(double), double a, double b, int subintervals);
; Parameters:  A pointer to the function that defines the mathematical function f(x)
;              to be integrated (RDI), the limits a (in XMM0) and b (in XMM1),
;              and the sub-intervals in (RSI).
; Return:      The area under the curve f(x), approximated by the sum of trapezoids,
;			defined by the subintervals.
; ==============================================================================
	PUSH RBP
	MOV RBP, RSP
	SUB RSP, 64

	MOV [FUNCTION], RDI
	MOV [N_INTERVALS], RSI
	VMOVSD [CURRENT_X], XMM0 
	MOV QWORD[PREVIOUS_X], 0 
	MOV QWORD[ITERATOR], 1
	MOV QWORD[ACCUMULATOR], 0

	VSUBSD XMM2, XMM1, XMM0
	VCVTSI2SD XMM3, RSI
	VDIVSD XMM2, XMM3 
	VMOVSD [STEP], XMM2 
	
	CMP RSI, 0
	Jle .calculationEnd
	
	.calculationLoop:
		; Compute f(x_k-1)
		VMOVSD XMM0, [CURRENT_X]
		MOV RDI, [FUNCTION]
		CALL RDI
		VMOVSD [CURRENT_RESULT], XMM0

		; Compute f(x_k)
		VMOVSD XMM0, [CURRENT_X]
		VMOVSD [PREVIOUS_X], XMM0
		VADDSD XMM0, [STEP]
		VMOVSD [CURRENT_X], XMM0
		MOV RDI, [FUNCTION]
		CALL RDI
		VADDSD XMM0, [CURRENT_RESULT]

		; Compute delta_x_k/2
		VMOVSD XMM1, [CURRENT_X]
		VSUBSD XMM1, [PREVIOUS_X]
		VDIVSD XMM1, [denominator]
		VMULSD XMM0, XMM1

		VADDSD XMM0, [ACCUMULATOR]
		VMOVSD [ACCUMULATOR], XMM0

		MOV RCX, [ITERATOR]
		INC RCX
		MOV [ITERATOR], RCX
		CMP RCX, [N_INTERVALS]
		Jbe .calculationLoop

	.calculationEnd:
	MOV RSP, RBP
	POP RBP
	RET 
