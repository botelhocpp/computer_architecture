; File: 		taylorseries.asm
; Author: 	Pedro Botelho
; Description:	Provices three functions to calculate the sine function: a function
;              that performs the expansion of the sine function in a Taylor series,
;              a function that performs the power of a double, and another that
;              performs the factorial of a double (in AVX2).
; Date: 		30/DEZ/2022

[BITS 64]

%INCLUDE "math.inc"

%DEFINE X_VALUE          RBP - 8
%DEFINE CURRENT_THERM    RBP - 16
%DEFINE ACCUMULATOR      RBP - 24

SECTION .rodata
sinSignalModifier DQ -1.0

SECTION .text

; ==============================================================================
GLOBAL sinTaylorSeries
sinTaylorSeries:
; Description: Calculates the value of the sine function, at a point x, using the
;              Taylor expansion (or Taylor series), with an approximation determined
;              by the number of terms given.
; Prototypes:  double sinTaylorSeries(double x, unsigned int therms);
; Parameters:  The point to be calculated (x) in XMM0 and the number of terms
;              (therms) in EDI. 
; Return:      The approximate result of the sine function at the point x in XMM0.
; ==============================================================================
	PUSH RBP
	MOV RBP, RSP
     SUB RSP, 32

     VMOVSD [X_VALUE], XMM0
     MOV QWORD[ACCUMULATOR], 0

     CMP EDI, 0
     Je .exitSin

     MOV ECX, EDI
     .computingSin:
          ; Signal
          VMOVSD XMM0, [sinSignalModifier]
          MOV EDI, ECX
          SUB EDI, 1
          CALL power
          VMOVSD [CURRENT_THERM], XMM0

          ; Denominator
          MOV EAX, 2
          MUL RCX
          SUB RAX, 1
          VCVTSI2SD XMM0, RAX
          CALL fatorial
          VMOVSD XMM1, [CURRENT_THERM]
          VDIVSD XMM1, XMM1, XMM0
          VMOVSD [CURRENT_THERM], XMM1

          ; x power
          MOV EDI, 2
          IMUL EDI, ECX
          SUB EDI, 1
          VMOVSD XMM0, [X_VALUE]
          CALL power

          ; Series therm
          VMULSD XMM0, XMM0, [CURRENT_THERM]

          ; Acummulate
          VMOVSD XMM1, [ACCUMULATOR]
          VADDSD XMM0, XMM0, XMM1
          VMOVSD [ACCUMULATOR], XMM0

          LOOP .computingSin

     .exitSin:
	MOV RSP, RBP
	POP RBP
	RET
