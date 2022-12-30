; File: 		taylorseries.asm
; Author: 	Pedro Botelho
; Description:	Provices three functions to calculate the sine function: a function
;              that performs the expansion of the sine function in a Taylor series,
;              a function that performs the power of a double, and another that
;              performs the factorial of a double (in AVX2).
; Date: 		30/DEZ/2022

[BITS 64]

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

     VMOVSD [RBP - 8], XMM0
     MOV QWORD[RBP - 24], -1
     MOV QWORD[RBP - 32], 0

     CMP EDI, 0
     Je .exitSin

     MOV ECX, EDI
     .computingSin:
          ; Signal
          VCVTSI2SD XMM0, [RBP - 24]
          MOV EDI, ECX
          SUB EDI, 1
          CALL power
          VMOVSD [RBP - 16], XMM0

          ; Denominator
          MOV EAX, 2
          MUL RCX
          SUB RAX, 1
          VCVTSI2SD XMM0, RAX
          CALL fatorial
          VMOVSD XMM1, [RBP - 16]
          VDIVSD XMM1, XMM1, XMM0
          VMOVSD [RBP - 16], XMM1

          ; x power
          MOV EDI, 2
          IMUL EDI, ECX
          SUB EDI, 1
          VMOVSD XMM0, [RBP - 8]
          CALL power

          ; Series therm
          VMULSD XMM0, XMM0, [RBP - 16]

          ; Acummulate
          VMOVSD XMM1, [RBP - 32]
          VADDSD XMM0, XMM0, XMM1
          VMOVSD [RBP - 32], XMM0

          LOOP .computingSin

     .exitSin:
     VMOVSD XMM0, [RBP - 32]
	MOV RSP, RBP
	POP RBP
	RET

; ==============================================================================
GLOBAL power
power:
; Description: Calculates the power n of the number a.
; Prototypes:  double power(double a, unsigned int n);
; Parameters:  The number to be calculated (a) in XMM0 and the power (n) in EDI.
; Return:      The power result a^n in XMM0.
; ==============================================================================
     PUSH RBP
     MOV RBP, RSP
     SUB RSP, 8
     MOV QWORD[RBP - 8], 1
     
     VCVTSI2SD XMM1, [RBP - 8]
     .powerInner:
          CMP EDI, 0
          Je .exitPower
          DEC EDI
          VMULSD XMM1, XMM1, XMM0
          JMP .powerInner

     .exitPower:
     VMOVSD XMM0, XMM1
     MOV RSP, RBP
     POP RBP
     RET

; ==============================================================================
GLOBAL fatorial
fatorial:
; Description: Calculates the fatorial of the number a.
; Prototypes:  double fatorial(double a);
; Parameters:  The number to have the factorial calculated (a) in XMM0.
; Return:      The fatorial result a! in XMM0.
; ==============================================================================
     PUSH RBP
     MOV RBP, RSP
     SUB RSP, 32
     MOV QWORD[RBP - 8], 3
     VCVTSI2SD XMM2, [RBP - 8]
     MOV QWORD[RBP - 16], 1
     VCVTSI2SD XMM3, [RBP - 16]
     
     VMOVSD XMM1, XMM0
     .fatorialInner:
          VMOVSD [RBP - 32], XMM0
          VCMPLTSD XMM0, XMM2
          VMOVQ [RBP - 24], XMM0
          CMP BYTE[RBP - 24], 0xFF
          Je .exitFatorial
          VMOVSD XMM0, [RBP - 32]
          VSUBSD XMM0, XMM0, XMM3
          VMULSD XMM1, XMM1, XMM0
          JMP .fatorialInner
        
     .exitFatorial:
     VMOVSD XMM0, XMM1
     MOV RSP, RBP
     POP RBP
     RET
     