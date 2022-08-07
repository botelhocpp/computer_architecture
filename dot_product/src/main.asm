; @file   main.asm
; @author Pedro Botelho
; @brief  A scalar product calculator. Put the size of
;         the two vectors in the top of the file, then,
;         in each line, put a double value. If the size
;         is 40, the put the size in the top, then 40 doubles
;         for vector 01, one on each line, then vector 02,
;         in the same manner.
; * in:   in/example01.txt
; * out:  Value of the Dot Product is: 440.00

[BITS 64]

%INCLUDE "dotproduct.inc"
%INCLUDE "sysvault.inc"
%INCLUDE "stdbool.inc"
%INCLUDE "stdlib.inc"
%INCLUDE "stdio.inc"

; main procedure local variables
%DEFINE INPUT_FILE_DESCRIPTOR      RBP - 4   ; int
%DEFINE VECTORS_SIZE               RBP - 8   ; int
%DEFINE VECTOR_01                  RBP - 16  ; double*
%DEFINE VECTOR_02                  RBP - 24  ; double*
%DEFINE PRODUCT_RESULT             RBP - 32  ; double

SECTION .rodata
scan_filename       DB "%s", 0x00 
welcome_string      DB "Enter the path of the file containing the vectors and their size:", 0x0A, 0x0D, 0x00
product_string      DB "Value of the Dot Product is: %.2lf", 0x0A, 0x0D, 0x00
file_error_string   DB "Error: Invalid file path!", 0x0A, 0x0D, 0x00
read_error_string   DB "Error: There was an error while reading the file!", 0x0A, 0x0D, 0x00
input_mode          DW 0x0000
output_mode         DW 0x01FF
input_flags         DW 0x0000
output_flags        DW 0x0242

SECTION .bss
filename            RESB 1024

SECTION .text
GLOBAL main
main:
     ; Constructs main function's Stack Frame,
     ; aligns the stack in 8-bytes boundaries
     ; and reserves 32-bytes for local variables.
     PUSH RBP
     MOV RBP, RSP
     SUB RSP, 32

     ; Prints a warm welcome message!
     LEA RDI, [welcome_string]
     XOR EAX, EAX
     CALL printf
     
     ; Gets the file name from the terminal.
     LEA RDI, [scan_filename]
     LEA RSI, [filename]
     XOR EAX, EAX
     CALL scanf

     ; Open file with the vectors.
     LEA RDI, [filename]
     MOV SI, [input_mode]
     MOVZX RSI, SI
     MOV DX, [input_flags]
     MOVZX RDX, DX
     CALL sysvOpenFile

     ; If file was not found, show an error message.
     CMP RAX, 0
     JLE .main_file_error

     ; Otherwise, retrieve file descriptor.
     MOV [INPUT_FILE_DESCRIPTOR], RAX

     ; Initialize the vectors pointer as NULL (0).
     MOV QWORD[VECTOR_01], NULL 
     MOV QWORD[VECTOR_02], NULL 

     ; Read vectors size (first line).
     MOV RDI, [INPUT_FILE_DESCRIPTOR] 
     LEA RSI, [VECTORS_SIZE] 
     CALL sysvGetFileLineInteger
     CMP RAX, FALSE
     JE .main_read_error

     ; Allocates memory for the vector one.
     MOV EDI, [VECTORS_SIZE]
     IMUL RDI, 8
     CALL malloc
     MOV [VECTOR_01], RAX 

     ; Allocates memory for the vector two.
     MOV EDI, [VECTORS_SIZE] 
     IMUL RDI, 8
     CALL malloc
     MOV [VECTOR_02], RAX 

     ; Fill vector one with the values from the file.
     MOV RDI, [INPUT_FILE_DESCRIPTOR] 
     MOV RSI, [VECTOR_01]
     MOV EDX, [VECTORS_SIZE]
     CALL fillVector 
     
     ; In the case of a read error, show an error message and exits.
     CMP RAX, FALSE
     JLE .main_read_error

     ; Fill vector two with the values from the file.
     MOV RDI, [INPUT_FILE_DESCRIPTOR] 
     MOV RSI, [VECTOR_02]
     MOV EDX, [VECTORS_SIZE]
     CALL fillVector 
     
     ; In the case of a read error, show an error message and exits.
     CMP RAX, FALSE
     JLE .main_read_error

     ; Computes the scalar product and puts it in memory.
     MOV RDI, [VECTOR_01]
     MOV RSI, [VECTOR_02]
     MOV EDX, [VECTORS_SIZE]
     CALL dotProductDouble
     VMOVSD [PRODUCT_RESULT], XMM0

     ; Shows the calculated value (in XMM0) on the terminal.
     LEA RDI, [product_string]
     MOV EAX, 1
     CALL printf

     .main_end:
     ;Free the memory allocated for vector one.
     MOV RDI, [VECTOR_01]
     CALL free

     ;Free the memory allocated for vector two.
     MOV RDI, [VECTOR_02]
     CALL free

     ;Close the input file.
     MOV RDI, [INPUT_FILE_DESCRIPTOR]
     CALL sysvCloseFile

     .main_exit:
     MOV RSP, RBP
     POP RBP
     XOR EAX, EAX
     RET

     .main_file_error:
          ; Shows an error message on the terminal.
          LEA RDI, [file_error_string]
          XOR EAX, EAX
          CALL printf
          JMP .main_exit

     .main_read_error:
          ; Shows an error message on the terminal.
          LEA RDI, [read_error_string]
          XOR EAX, EAX
          CALL printf
          JMP .main_end

GLOBAL fillVector
fillVector:
     PUSH RBP
     MOV RBP, RSP

     MOV RCX, RDX

     .fillVector_loop:
          PUSH RDI
          PUSH RSI
          PUSH RCX
          CALL sysvGetFileLineDouble
          CMP RAX, FALSE
          JLE .fillVector_exit
          POP RCX
          POP RSI
          POP RDI
          ADD RSI, 8
          LOOP .fillVector_loop

     MOV RAX, TRUE

     .fillVector_exit:
     MOV RSP, RBP
     POP RBP
     RET