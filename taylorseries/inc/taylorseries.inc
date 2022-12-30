; File: 		taylorseries.asm
; Author: 	Pedro Botelho
; Description:	Defines three functions to calculate the sine function: a function
;              that performs the expansion of the sine function in a Taylor series,
;              a function that performs the power of a double, and another that
;              performs the factorial of a double (in AVX2).
; Date: 		30/DEZ/2022

%IFNDEF TAYLOR_SERIES_INC
%DEFINE TAYLOR_SERIES_INC

; ==============================================================================
EXTERN sinTaylorSeries
; Description: Calculates the value of the sine function, at a point x, using the
;              Taylor expansion (or Taylor series), with an approximation determined
;              by the number of terms given.
; Prototypes:  double sinTaylorSeries(double x, unsigned int therms);
; Parameters:  The point to be calculated (x) in XMM0 and the number of terms
;              (therms) in EDI. 
; Return:      The approximate result of the sine function at the point x in XMM0.
; ==============================================================================

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
