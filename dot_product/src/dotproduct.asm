; @file   dotproduct.asm
; @author Pedro Botelho
; @brief  Provides functions for calculating
;         dot product, vector of floats and
;         doubles.

[BITS 64]

SECTION .text

; ==============================================================================
GLOBAL dotProductFloat
dotProductFloat:
; Description: Multiplies the corresponding elements of two vectors, and sums
;              the resulting vector by a scalar value.
; Prototype:   float dotProductFloat(float *vector01, float *vector02, unsigned int size);
; Arguments:   The address of the two operand float arrays (in RDI and RSI) and
;              the size of the arrays (in RDX).
; Return:      XMM0 with the scalar product of the two vectors.
; ============================================================================= 
     PUSH RBP
     MOV RBP, RSP

     ; Obtains size/8 for counter, since it'll be
     ; 8 multiplications per iteration.
     MOV RAX, RDX
     MOV RDX, 0
     MOV RCX, 8
     DIV RCX
     MOV RCX, RAX
     
     ; Zero XMM2 to use as an accumulator.
     MOV RAX, 0
     VMOVQ XMM2, RAX
     
     .dotProduct_loop:
          ; Get the OFFSET (the 8 floats to fetch from memory).
          MOV RAX, RCX
          DEC RAX      
          IMUL RAX, 32 
     
          ; Move 8 floats at the time (no 16-bytes boundary).
          VMOVUPS YMM0, [RDI + RAX]
          VMOVUPS YMM1, [RSI + RAX]
        
          ; Multiply each corresponding float.
          VMULPS YMM0, YMM1
          CALL horizontalSumFloat
        
          ; Accumulate the horizontal sum result.
          VADDSS XMM2, XMM0
     
          ; Repeat
          LOOP .dotProduct_loop
     
     VMOVSS XMM0, XMM2

     MOV RSP, RBP
     POP RBP
     RET

; ==============================================================================
GLOBAL dotProductDouble
dotProductDouble:
; Description: Multiplies the corresponding elements of two vectors, and sums
;              the resulting vector by a scalar value.
; Prototype:   double dotProductDouble(double *vector01, double *vector02, unsigned int size);
; Arguments:   The address of the two operand double arrays (in RDI and RSI) and
;              the size of the arrays (in RDX).
; Return:      XMM0 with the scalar product of the two vectors.
; ============================================================================= 
     PUSH RBP
     MOV RBP, RSP

     ; Obtains size/4 for counter, since it'll be
     ; 8 multiplications per iteration.
     MOV RAX, RDX
     MOV RDX, 0
     MOV RCX, 4
     DIV RCX
     MOV RCX, RAX
     
     ; Zero XMM2 to use as an accumulator.
     MOV RAX, 0
     VMOVQ XMM2, RAX
     
     .dotProduct_loop:
          ; Get the OFFSET (the 4 doubles to fetch from memory).
          MOV RAX, RCX
          DEC RAX      
          IMUL RAX, 32 
     
          ; Move 8 floats at the time (no 16-bytes boundary).
          VMOVUPD YMM0, [RDI + RAX]
          VMOVUPD YMM1, [RSI + RAX]
        
          ; Multiply each corresponding float.
          VMULPD YMM0, YMM1
          CALL horizontalSumDouble
        
          ; Accumulate the horizontal sum result.
          VADDSD XMM2, XMM0
     
          ; Repeat
          LOOP .dotProduct_loop
     
     VMOVSD XMM0, XMM2

     MOV RSP, RBP
     POP RBP
     RET

; ==============================================================================
GLOBAL horizontalSumFloat
horizontalSumFloat:
; Description: Sum all 8 vector elements into a single scalar.
; Prototype:   float horizontalSumFloat(__m256 array);
; Arguments:   YMM0 with the elements to be added.
; Return:      XMM0 with the sum of the elements.
; ============================================================================= 
     PUSH RBP
     MOV RBP, RSP

     ; Horizontal sum of the array of floats.
     VHADDPS YMM0, YMM0
        
     ; Extract Upper 128-bits of YMM0.
     VEXTRACTF128 XMM1, YMM0, 1

     ; Add the Upper half of the sum to the lower half.
     VADDPS XMM0, XMM0, XMM1 

     ; Sum the two remaining elements of the vector in a scalar.
     VHADDPS XMM0, XMM0    

     MOV RSP, RBP
     POP RBP
     RET

; ==============================================================================
GLOBAL horizontalSumDouble
horizontalSumDouble:
; Description: Sum all 4 vector elements into a single scalar.
; Prototype:   float horizontalSumDouble(__m256d array);
; Arguments:   YMM0 with the elements to be added.
; Return:      XMM0 with the sum of the elements.
; ============================================================================= 
     PUSH RBP
     MOV RBP, RSP

     ; Horizontal sum of the array of floats.
     VHADDPD YMM0, YMM0
        
     ; Extract Upper 128-bits of YMM0.
     VEXTRACTF128 XMM1, YMM0, 1

     ; Add the Upper half of the sum to the lower half.
     VADDPD XMM0, XMM0, XMM1    

     MOV RSP, RBP
     POP RBP
     RET