; ==============================================================================
; File: 	     mainPolynomial.asm
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
%INCLUDE "polynomial.inc"

%DEFINE A_LIMIT 	     RBP - 8
%DEFINE B_LIMIT 	     RBP - 16
%DEFINE N_INTERVALS 	RBP - 24
%DEFINE RESULT 	     RBP - 32
%DEFINE ITERATOR 	     RBP - 40

SECTION .bss
polynomialDegree         RESQ 1
polynomialCoefficients   RESQ 1

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
     LEA RSI, [polynomialDegree]
     XOR EAX, EAX
     CALL scanf

     MOV RDI, [polynomialDegree]
     INC RDI
     IMUL RDI, 8
     CALL malloc

     CMP RAX, 0
     Jle .mallocError

     MOV [polynomialCoefficients], RAX

     XOR ECX, ECX
     .getCoefficientsLoop:
          MOV [ITERATOR], RCX
          
          LEA RDI, [strGetCoefficients]
          MOV RSI, [polynomialCoefficients]
          IMUL RCX, 8
          ADD RSI, RCX
          XOR EAX, EAX
          CALL scanf

          MOV RCX, [ITERATOR]
          INC RCX
          CMP RCX, [polynomialDegree]
          Jle .getCoefficientsLoop

     LEA RDI, [strGetParameters]
     LEA RSI, [A_LIMIT]
     LEA RDX, [B_LIMIT]
     LEA RCX, [N_INTERVALS]
     XOR EAX, EAX
     CALL scanf

     LEA RDI, [fifthDegreePolynomialFunction]
     MOV RSI, [N_INTERVALS]
     VMOVSD XMM0, [A_LIMIT]
     VMOVSD XMM1, [B_LIMIT]
     CALL trapezoidalApproximation
     VMOVSD [RESULT], XMM0

     LEA RDI, [strPutResult]
     MOV RSI, [polynomialDegree]
     MOV RDX, [N_INTERVALS]
     VMOVSD XMM0, [A_LIMIT]
     VMOVSD XMM1, [B_LIMIT]
     VMOVSD XMM2, [RESULT]
     MOV EAX, 3
     CALL printf

     MOV RDI, [polynomialCoefficients]
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

GLOBAL fifthDegreePolynomialFunction
fifthDegreePolynomialFunction:
	PUSH RBP
	MOV RBP, RSP

     MOV RDI, [polynomialCoefficients]
	MOV RSI, [polynomialDegree]
	CALL polynomialFunction

	MOV RSP, RBP
	POP RBP
	RET
