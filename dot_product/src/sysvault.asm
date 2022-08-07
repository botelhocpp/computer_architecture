; @file   sysvault.asm
; @author Pedro Botelho
; @brief  Some useful system calls and functions
;         for managing files as well as devices
;         and memory.

[BITS 64]

%INCLUDE "stdlib.inc"
%INCLUDE "stdbool.inc"

SECTION .text

; ==============================================================================  
GLOBAL sysvOpenFile
sysvOpenFile:
; Description: Opens a file, based on flags (file handling options) and mode
;              (access permissions).
; Prototype:   FILE *sysvOpenFile(char *filename, int flags, int mode);
; Argments:    RDI with the file name (address of the string).
;              RSI with the flags.
;              RDX with the mode.
; Return:      The file descriptor.
; ============================================================================== 
     PUSH RBP
     MOV RBP, RSP

     MOV RAX, 2
     SYSCALL

     MOV RSP, RBP
     POP RBP
     RET

; ==============================================================================  
GLOBAL sysvCloseFile
sysvCloseFile:
; Description: Closes a file.
; Prototype:   void sysvCloseFile(FILE *fp);
; Argments:    RDI with the file descriptor.
; Return:      Nothing.
; ============================================================================== 
     PUSH RBP
     MOV RBP, RSP

     MOV RAX, 3
     SYSCALL

     MOV RSP, RBP
     POP RBP
     RET

; ==============================================================================  
GLOBAL sysvReadFileLine
sysvReadFileLine:
; Description: Reads a line from the file, until it finds a line break.
; Prototype:   int sysvReadFileLine(FILE *fp, char *buffer);
; Argments:    RDI with the file descriptor.
;              RSI with the buffer (to place the file contents).
; Return:      Number of bytes read.
; ============================================================================== 
     PUSH RBP
     MOV RBP, RSP
     SUB RSP, 8
     PUSH R8

     MOV RBX, RSI
     LEA RSI, [RBP - 8]
     MOV R8, 0
     MOV RDX, 1
     .sysvReadFileLine_loop:
          MOV RAX, 0
          SYSCALL
          CMP RAX, 0
          JLE .sysvReadFileLine_end
          MOV CL, BYTE[RSI]
          CMP CL, 10
          JE .sysvReadFileLine_end
          MOV [RBX], CL
          INC RBX
          ADD R8, RAX
          JMP .sysvReadFileLine_loop

     .sysvReadFileLine_end:
     MOV RAX, R8
     POP R8
     MOV RSP, RBP
     POP RBP
     RET

; ==============================================================================  
GLOBAL sysvClearMemory
sysvClearMemory:
; Description: Clears a given number of bytes starting from the given memory
;              address.
; Prototype:   void sysvClearMemory(void *ptr, unsigned int bytes);
; Argments:    RDI with the initial address of the memory.
;              RSI with the number of bytes to be erased.
; Return:      Nothing.
; ============================================================================== 
     PUSH RBP
     MOV RBP, RSP

     DEC RSI

     .sysvClearMemory_loop:
          MOV BYTE[RDI + RSI], 0
          DEC RSI
          CMP RSI, 0
          JGE .sysvClearMemory_loop

     MOV RSP, RBP
     POP RBP
     RET

; ==============================================================================  
GLOBAL sysvGetFileLineInteger
sysvGetFileLineInteger:
; Description: Gets an integer of the current line of the given file, puts it in
;              the given address and returns if the operation was successful.
; Prototype:   bool sysvGetFileLineInteger(FILE *fp, int *file_integer);
; Argments:    RDI with the file descriptor.
;              RSI with the buffer to place the integer.
; Return:      RAX with the operation status.
; ==============================================================================  
     PUSH RBP
     MOV RBP, RSP
     SUB RSP, 64

     PUSH RSI
     PUSH RDI

     LEA RDI, [RBP - 64]
     MOV RSI, 64
     CALL sysvClearMemory

     POP RDI

     LEA RSI, [RBP - 64]
     CALL sysvReadFileLine
     CMP RAX, 0
     JLE .sysvGetFileLineInteger_false

     LEA RDI, [RBP - 64]
     CALL atoi

     POP RSI

     MOV [RSI], EAX

     .sysvGetFileLineInteger_true:
     MOV RAX, TRUE

     .sysvGetFileLineInteger_end:
     MOV RSP, RBP
     POP RBP
     RET

     .sysvGetFileLineInteger_false:
     MOV RAX, FALSE
     JMP .sysvGetFileLineInteger_end


; ==============================================================================  
GLOBAL sysvGetFileLineDouble
sysvGetFileLineDouble:
; Description: Gets a double of the current line of the given file, puts it in
;              the given address and returns if the operation was successful.
; Prototype:   bool sysvGetFileLineDouble(FILE *fp, double *file_double);
; Argments:    RDI with the file descriptor.
;              RSI with the buffer to place the double.
; Return:      RAX with the operation status.
; ==============================================================================  
     PUSH RBP
     MOV RBP, RSP
     SUB RSP, 64

     PUSH RSI
     PUSH RDI

     LEA RDI, [RBP - 64]
     MOV RSI, 64
     CALL sysvClearMemory

     POP RDI

     LEA RSI, [RBP - 64]
     CALL sysvReadFileLine
     CMP RAX, 0
     JLE .sysvGetFileLineDouble_false

     LEA RDI, [RBP - 64]
     CALL atof

     POP RSI

     VMOVSD [RSI], XMM0

     .sysvGetFileLineDouble_true:
     MOV RAX, TRUE

     .sysvGetFileLineDouble_end:
     MOV RSP, RBP
     POP RBP
     RET

     .sysvGetFileLineDouble_false:
     MOV RAX, FALSE
     JMP .sysvGetFileLineDouble_end
