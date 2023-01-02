; ==============================================================================
; File: 	     mainSin.asm
; Author:      Pedro Botelho
; Description: Approximates the integral of a sin function using the trapezoid
;              rule. Receives the number of therms of the taylor series, the
;              intervals a and b, and the number of subintervals that will
;              approximate the integral.
; Date:        02/JAN/2023
; ==============================================================================

[BITS 64]

%INCLUDE "stdio.inc"
%INCLUDE "trapezoidal.inc"
%INCLUDE "taylorseries.inc"

%DEFINE A_LIMIT 	     RBP - 8
%DEFINE B_LIMIT 	     RBP - 16
%DEFINE N_INTERVALS 	RBP - 24
%DEFINE RESULT 	     RBP - 32
%DEFINE ITERATOR 	     RBP - 40

SECTION .bss
sinTherms           RESQ 1

SECTION .rodata
strGetParameters    DB "%ld%lf%lf%ld", 0x00
strPutResult        DB "Integral of the Taylor expansion of sin(x), with %ld therms, from %.2lf to %.2lf, with %ld sub-intervals is: %lf.", 0x0A, 0x00

SECTION .text
GLOBAL main
main:
	PUSH RBP
	MOV RBP, RSP
     SUB RSP, 64

     LEA RDI, [strGetParameters]
     LEA RSI, [sinTherms]
     LEA RDX, [A_LIMIT]
     LEA RCX, [B_LIMIT]
     LEA R8, [N_INTERVALS]
     XOR EAX, EAX
     CALL scanf

     LEA RDI, [sinFunction]
     MOV RSI, [N_INTERVALS]
     VMOVSD XMM0, [A_LIMIT]
     VMOVSD XMM1, [B_LIMIT]
     CALL trapezoidalApproximation
     VMOVSD [RESULT], XMM0

     LEA RDI, [strPutResult]
     MOV RSI, [sinTherms]
     MOV RDX, [N_INTERVALS]
     VMOVSD XMM0, [A_LIMIT]
     VMOVSD XMM1, [B_LIMIT]
     VMOVSD XMM2, [RESULT]
     MOV EAX, 3
     CALL printf

.mainExit:
	MOV RSP, RBP
	POP RBP
	XOR EAX, EAX
	RET

GLOBAL sinFunction
sinFunction:
	PUSH RBP
	MOV RBP, RSP

     MOV RDI, [sinTherms]
	CALL sinTaylorSeries

	MOV RSP, RBP
	POP RBP
	RET
