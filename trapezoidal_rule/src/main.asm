; ==============================================================================
; File: 	     main.asm
; Author:      Pedro Botelho
; Description: Approximates the integral of a polynomial function using the 
;              trapezoid rule. Receives the degree of a polynomial function, its
;              coefficients, the intervals a and b, and the number of subintervals
;              that will approximate the integral.
; Date:        02/JAN/2023
; ==============================================================================

[BITS 64]

%INCLUDE "stdio.inc"
%INCLUDE "stdlib.inc"
%INCLUDE "trapezoidal.inc"

%DEFINE DEGREE 		RBP - 8
%DEFINE COEFFICIENTS 	RBP - 16
%DEFINE A_LIMIT 	     RBP - 24
%DEFINE B_LIMIT 	     RBP - 32
%DEFINE N_INTERVALS 	RBP - 40
%DEFINE RESULT 	     RBP - 48
%DEFINE ITERATOR 	     RBP - 56

SECTION .rodata
strGetDegree        DB "%ld", 0x00
strGetCoefficients  DB "%lf", 0x00
strGetParameters    DB "%lf%lf%ld", 0x00
strPutResult        DB "Integral of p(x), of degree %ld, from %.2lf to %.2lf, with %ld sub-intervals is: %lf.", 0x0A, 0x00
strMallocError      DB "An error occurred while allocating memory.", 0x0A, 0x00

SECTION .text
GLOBAL main
main:
	PUSH RBP
	MOV RBP, RSP
     SUB RSP, 64

     LEA RDI, [strGetDegree]
     LEA RSI, [DEGREE]
     XOR EAX, EAX
     CALL scanf

     MOV RDI, [DEGREE]
     INC RDI
     IMUL RDI, 8
     CALL malloc

     CMP RAX, 0
     Jle .mallocError

     MOV [COEFFICIENTS], RAX

     XOR ECX, ECX
     .getCoefficientsLoop:
          MOV [ITERATOR], RCX
          
          LEA RDI, [strGetCoefficients]
          MOV RSI, [COEFFICIENTS]
          IMUL RCX, 8
          ADD RSI, RCX
          XOR EAX, EAX
          CALL scanf

          MOV RCX, [ITERATOR]
          INC RCX
          CMP RCX, [DEGREE]
          Jle .getCoefficientsLoop

     LEA RDI, [strGetParameters]
     LEA RSI, [A_LIMIT]
     LEA RDX, [B_LIMIT]
     LEA RCX, [N_INTERVALS]
     XOR EAX, EAX
     CALL scanf

     MOV RDI, [COEFFICIENTS]
     MOV RSI, [DEGREE]
     MOV RDX, [N_INTERVALS]
     VMOVSD XMM0, [A_LIMIT]
     VMOVSD XMM1, [B_LIMIT]
     CALL trapezoidalApproximationPolynomial
     VMOVSD [RESULT], XMM0

     LEA RDI, [strPutResult]
     MOV RSI, [DEGREE]
     MOV RDX, [N_INTERVALS]
     VMOVSD XMM0, [A_LIMIT]
     VMOVSD XMM1, [B_LIMIT]
     VMOVSD XMM2, [RESULT]
     MOV EAX, 3
     CALL printf

     MOV RDI, [COEFFICIENTS]
     CALL free

.mainExit:
	MOV RSP, RBP
	POP RBP
	XOR EAX, EAX
	RET
     
.mallocError:
     LEA RDI, [strMallocError]
     MOV EAX, 0
     CALL printf
     JMP .mainExit
