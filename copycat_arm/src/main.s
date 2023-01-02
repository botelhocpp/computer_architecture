@-------------------------------------------------------------------
@ File:           main.s
@ Author:         Pedro Botelho
@ Date:           18/04/2021
@ Institution:    Federal University of Ceará
@ Institution ID: 471047
@
@ Description:    Copies data from one file to another. The input file
@                 must exist. The output file can be inexistent.
@ Implementation: Developed in ARM 32-bit Assembly.
@ Compiling:      make all
@ License:        GNU General Public License v3.0
@-------------------------------------------------------------------

.TEXT

.ARM
	
.INCLUDE "copycat.lib"

.GLOBAL main

main:
	@SET r10 AS STACK BASE
	MOV r10, sp

	@SHOW WELCOME MESSAGE
	LDR r1, =write_pleadString
	BL _printString
	
	@GET INPUT FILE's NAME
	LDR r4, =inputFile
	BL _getInput

	@GET OUTPUT FILE's NAME
	LDR r4, =outputFile
	BL _getInput
	 
	@OPENING INPUT FILE
        LDR r0, =inputFile
	MOV r1, #DONT_CREATE
	MOV r2, #READ_ONLY
	LDR r5, =inputFD
	BL _openFile
	
	@SET r8 AS INPUT FD
	MOV r8, r0	
	
	@OPENING OUTPUT FILE
	LDR  r0, =outputFile
	LDR  r1, =CREATE_WRITE
	LDR  r2, =PERMISSIONS
	LDR  r5, =outputFD
	BL  _openFile

	@SET r9 AS OUTPUT FD
	MOV r9, r0
	
	BL _copyFile

	@SHOW GOODBYE MESSAGE
	LDR r1, =goodbyeString
	BL _printString

	@CLOSING GILES
	MOV r0, r8
	BL _closeFile
	MOV r0, r9
	BL _closeFile
	
	@RESTORE STACK POINTER
	MOV sp, r10

	@EXIT SYSCALL
	MOV r7, #EXIT_FUNCTION
	SWI #0
	
	
.BALIGN 4
.DATA
write_pleadString: .ASCIZ "WELCOME TO COPYCAT ASSISTANT\n\nType down the path of the input file, then the output file.\n"
goodbyeString:     .ASCIZ "\nAll set. Exiting assistant.\n"

@User variables
inputFile:  .SKIP 100
inputFD:    .SKIP 4
outputFile: .SKIP 100
outputFD:   .SKIP 4
