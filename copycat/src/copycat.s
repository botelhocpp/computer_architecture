@-------------------------------------------------------------------
@ File:           copycat.s
@ Author:         Pedro Botelho
@ Date:           13/06/2021
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


@-------------------------------------------------------------------
_end:
@ Description: Restore stack pointer to default position and exit.
@ Receives:    Nothing.
@ Returns:     Nothing.
@-------------------------------------------------------------------
	@RESTORE STACK POINTER
	MOV sp, r10

	@EXIT SYSCALL
	MOV r7, #EXIT_FUNCTION
	SWI #0


@-------------------------------------------------------------------
_getInput:
@ Description: Get user's input from keyboard.
@ Receives:    Memory address where the string must be placed.
@ Returns:     The string in the desired address.
@-------------------------------------------------------------------
	PUSH {LR}
	MOV r7, #READ_FUNCTION
	MOV r0, #STD_IN
	MOV r2, #OPERATE_ONE_BYTE
	LDR r1, =tempBuffer 
	__inner_getInput:
		SWI #0
		LDRB r3, [r1]
		CMP r3, #LINE_FEED
		POPeq {PC}
		CMP r3, #SPACE
		POPeq {PC}
		STRB r3, [r4]
		ADD r4, r4, #1 
		B __inner_getInput


@-------------------------------------------------------------------
_openFile:
@ Description: Opens the desired file.
@ Receives:    The file path/name in r0, flags in r1, and permissions
@              in r2. Also the address where the FD will me saved in
@              r5. Some explanations:
@	       -> Flags: states how the file will be handled. For an
@                        example: 0x40 create the file if it doesn't
@                        exist, and 0x1 define the write-only access
@                        mode. Hence, 0x40|0x1=0x41 represent both.  
@	       -> Permissions: formally called 'mode' states who can 
@                              access and what can be done with it.
@                              For example, 0x1FF gives all user 
@                              read, write and execution permissions.
@ Returns:     The file descriptor, FD, in r0. In case of some error
@              r0 will receive a number bellow or equal to zero, show
@              an error message and exit.
@-------------------------------------------------------------------
	PUSH {LR}
	MOV r7, #OPEN_FUNCTION
	SWI #0
	CMP r0, #ERROR
	Ble _fileError
	STR r0, [r5]
	POP {PC}


@-------------------------------------------------------------------
_closeFile:
@ Description: Closes the required file.
@ Receives:    The file descriptor in r0.
@ Returns:     Nothing.
@-------------------------------------------------------------------
	PUSH {LR}
	MOV r7, #CLOSE_FUNCTION
	SWI #0
	POP {PC}


@-------------------------------------------------------------------
_copyFile:
@ Description: Copies data from an input file to an output file.
@ Receives:    The input FD in r8 and the output FD in r9.
@ Returns:     Nothing.
@-------------------------------------------------------------------
	PUSH {LR}
	LDR r1, =tempBuffer
	MOV r2, #OPERATE_ONE_BYTE
	_readFile:
		MOV r0, r8
		MOV r7, #READ_FUNCTION
		SWI #0
		CMP r0, #END_OF_FILE
		POPle {PC}
	_writeFile:
		MOV r0, r9
		MOV r7, #WRITE_FUNCTION
		SWI #0	
		B _readFile

@-------------------------------------------------------------------
_fileToString:
@ Description: Copies data from a file to memory
@ Receives:    The string address, where the data will be placed, in 
@              r1, and the input file descriptor, in r8.
@ Returns:     The data in the requested string, in memory.
@-------------------------------------------------------------------
	PUSH {LR}
	MOV r2, #OPERATE_ONE_BYTE
	__inner_fileToString:
		MOV r0, r8
		MOV r7, #READ_FUNCTION
		SWI #0
		CMP r0, #END_OF_FILE
		POPle {PC}
		ADD r1, r1, #1 
		B __inner_fileToString

@-------------------------------------------------------------------
_printString:
@ Description: Prints a message in the terminal.
@ Receives:    The string address in r1.
@ Returns:     Nothing.
@-------------------------------------------------------------------
	PUSH {LR}
	MOV R7, #WRITE_FUNCTION
	MOV R0, #STD_OUT
	MOV R2, #OPERATE_ONE_BYTE
	__inner_printString:
		SWI #0	
		ADD r1, r1, #1
		LDRB r3, [r1]
		CMP r3, #END_OF_STRING
		Bne __inner_printString	
	POP {PC}


@-------------------------------------------------------------------
_fileError:
@ Description: Prints an error message and exits.
@ Receives:    Nothing.
@ Returns:     Nothing.
@-------------------------------------------------------------------
	LDR r1, =fileErrorString
	BL _printString
	B _end

.DATA
.BALIGN 4

@System Strings
fileErrorString:   .ASCIZ "\nSpecified input file doesn't exist.\nAborting.\n"
tempBuffer:        .BYTE 1
