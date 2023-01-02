; ==============================================================================
; File: 	math.inc
; Author:     	Pedro Botelho
; Description:	Defines functions that perform various mathematical operations.
; Date:       	02/JAN/2023
; ==============================================================================

%IFNDEF MATH_INC
%DEFINE MATH_INC

; ==============================================================================
EXTERN power
; Description: Calculates the power n of the number a.
; Prototypes:  double power(double a, unsigned int n);
; Parameters:  The number to be calculated (a) in XMM0 and the power (n) in EDI.
; Return:      The power result a^n in XMM0.
; ==============================================================================

; ==============================================================================
EXTERN fatorial
; Description: Calculates the fatorial of the number a.
; Prototypes:  double fatorial(double a);
; Parameters:  The number to have the factorial calculated (a) in XMM0.
; Return:      The fatorial result a! in XMM0.
; ==============================================================================

%ENDIF
