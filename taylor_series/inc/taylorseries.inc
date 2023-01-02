; File:	taylorseries.asm
; Author: 	Pedro Botelho
; Description:	Provices a function to calculate the sine function: a function
;             	that performs the expansion of the sine function in a Taylor series.
;			(in AVX2).
; Date: 	02/JAN/2022

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

%ENDIF
