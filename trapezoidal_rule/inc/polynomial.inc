; ==============================================================================
; File: 	     polynomial.asm
; Author:      Pedro Botelho
; Description: Defines a function that represents a polynomial mathematical function.
; Date:        02/JAN/2023
; ==============================================================================

%IFNDEF POLYNOMIAL_INC
%DEFINE POLYNOMIAL_INC

; ==============================================================================
EXTERN polynomialFunction
; Description: Calculate the result of a polynomial function of given degree, at
;			a given point x.
; Prototypes:  double polynomialFunction(double *coefficients, unsigned int degree, double x);
; Parameters:  A pointer to the function coefficients, in RDI, the degree of the 
;			function, in RSI, and the point x of interest, in XMM0.
; Return:      The function result, p(x) at given x, in XMM0.
; ==============================================================================

%ENDIF