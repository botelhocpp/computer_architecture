; ==============================================================================
; File: 	     trapezoidal.asm
; Author:      Pedro Botelho
; Description: Defines a function that approximates the integral of a polynomial
;			function p(x) using the trapezoidal rule.
; Date:        02/JAN/2023
; ==============================================================================

%IFNDEF TRAPEZOIDAL_INC
%DEFINE TRAPEZOIDAL_INC

; ==============================================================================
EXTERN trapezoidalApproximationPolynomial
; Description: Approximates the integral of a polynomial function of degree n from
;			a to b using the trapezoidal rule. Subintervals are defined between
;			a and b, in order to approximate the integral.
; Prototypes:  double trapezoidalApproximationPolynomial(double *coefficients, int degree, double a, double b, int subintervals);
; Parameters:  A pointer to the coefficients of the function (RDI), the degree of the
;			function (RSI), the limits a (in XMM0) and b (in XMM1), and the
;			sub-intervals in (RDX).
; Return:      The area under the curve p(x), approximated by the sum of trapezoids,
;			defined by the subintervals.
; ==============================================================================

; ==============================================================================
EXTERN trapezoidalApproximation
; Description: Approximates the integral of a given function f(x), from a to b using
;              the trapezoidal rule. Subintervals are defined between a and b,
;              in order to approximate the integral.
; Prototypes:  double trapezoidalApproximation(double (*function)(double), double a, double b, int subintervals);
; Parameters:  A pointer to the function that defines the mathematical function f(x)
;              to be integrated (RDI), the limits a (in XMM0) and b (in XMM1),
;              and the sub-intervals in (RSI).
; Return:      The area under the curve f(x), approximated by the sum of trapezoids,
;			defined by the subintervals.
; ==============================================================================

%ENDIF