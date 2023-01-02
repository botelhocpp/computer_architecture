; ==============================================================================
; File: 	math.asm
; Author:    	Pedro Botelho
; Description:	Defines functions that perform various mathematical operations.
; Date:       	02/JAN/2023
; ==============================================================================

[BITS 64]

SECTION .rodata
powerDefaultReturn            DQ 1.0
fatorialZero                  DQ 0
fatorialZeroFatorial          DQ 1.0
fatorialDecrement             DQ 1.0
fatorialMinimalSignificant    DQ 3.0

SECTION .text

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
     
     VMOVSD XMM1, [powerDefaultReturn]
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
     SUB RSP, 16
     
     ; Verify if "a" is equal to 0.
     VMOVQ XMM1, XMM0
     VCMPEQSD XMM0, [fatorialZero]
     VMOVQ [RBP - 8], XMM0
     CMP BYTE[RBP - 8], 0xFF
     Je .exitFatorialZero

     VMOVQ XMM0, XMM1
     VMOVSD XMM2, [fatorialMinimalSignificant]
     VMOVSD XMM3, [fatorialDecrement]

     .fatorialInner:
          VMOVSD [RBP - 16], XMM0
          VCMPLTSD XMM0, XMM2
          VMOVQ [RBP - 8], XMM0
          CMP BYTE[RBP - 8], 0xFF
          Je .exitFatorial
          VMOVSD XMM0, [RBP - 16]
          VSUBSD XMM0, XMM0, XMM3
          VMULSD XMM1, XMM1, XMM0
          JMP .fatorialInner
        
     .exitFatorial:
     VMOVSD XMM0, XMM1
     
     .exitFunction:
     MOV RSP, RBP
     POP RBP
     RET

     .exitFatorialZero:
          VMOVSD XMM0, [fatorialZeroFatorial]
          JMP .exitFunction
