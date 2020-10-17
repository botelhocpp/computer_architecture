;some simple macros to make it 'pretty'
%DEFINE REMOVE_EIGHT_BYTES 8
%DEFINE ROUTE_EIGHT_BYTES  8
%DEFINE CONSTANT_ZERO      0
%DEFINE CONSTANT_ONE       1
%DEFINE CONSTANT_TWO       2
%DEFINE CLEAR_DIVIDEND     0
%DEFINE CLEAR_INT_PAR      4
%DEFINE RETURN_ZERO        0

;some gcc external functions
EXTERN printf
EXTERN scanf

SECTION .data
intInputParameter  DB "%d", 0
intOutputParameter DB "%d", 13, 10, 0
constantTwo        DD 2

SECTION .bss
inputValue  RESD 1
outputValue RESD 1

SECTION .text
GLOBAL main
main:
       ;prepares the stack frame
	PUSH EBP
	MOV  EBP, ESP
	
       ;push the argument(address) in the stack 
       ;and calls the scanning procedure
       PUSH inputValue
       CALL SCAN_INT
       
       ;clear the dividend for the DIV instruction
       MOV  EDX, CLEAR_DIVIDEND
	
       ;push the argument(value) in the stack 
       ;and calls the calculation procedure procedure     
	PUSH DWORD[inputValue]
	CALL CALC_LOG
	
       ;passes the final value of EAX to memory
       MOV  [outputValue], EAX
	
       ;push the argument(value) in the stack 
       ;and calls the printing procedure
       PUSH DWORD[outputValue]
       CALL PRINT_INT
       
       ;destroys the stack frame
	MOV  ESP, EBP
	POP  EBP
       
       ;returns zero to the main procedure
	XOR  EAX, EAX
	RET

;---------------------------------------------------------------
CALC_LOG:
; Description: Calculates the logarithm on base 2¹ of a number.
;              ¹Consider log2(x) = y and 2^y = x. 
; Receives:    The value "x" by the stack.
; Returns:     The "y" value in EAX.
;---------------------------------------------------------------
	PUSH EBP
	MOV  EBP, ESP   
       
       ;passes the final value of the stack to EAX
 	MOV  EAX, [EBP+ROUTE_EIGHT_BYTES]
 
       ;if (EAX < 2) then "return zero to the procedure"
       ;and RET will 'cleanse' the recursive calls 
       ;if (EAX >= 2) proceed to the recursion calls 
       ;if (EAX <= 1) return 0
	CMP  EAX, CONSTANT_TWO
	JA   RECURSIVE_CALL
	CMP  EAX, CONSTANT_ONE
	MOV  EAX, RETURN_ZERO
	JMP  RECURSIVE_RETURN

       ;"divide and conquer" process until EAX < 2
RECURSIVE_CALL:
	DIV  DWORD[constantTwo]
	PUSH EAX
	CALL CALC_LOG
       
       ;this process is to 'count' the recursive calls
       ;therefore, make the logarithm count
       ;also the 94 and 79 line instruction is to prevent x = 1/0 -> y = 1 
RECURSIVE_RETURN:
	MOV  EBX, [EBP+ROUTE_EIGHT_BYTES]
       JBE  QUIT
	ADD  EAX, CONSTANT_ONE 
	
       ;destroys the stack frame and clear the 
       ;initial procedure's parameter
QUIT:       
	MOV  ESP, EBP
	POP  EBP
	RET  CLEAR_INT_PAR

;---------------------------------------------------------------
SCAN_INT:
; Description: Scans an integer entered by the user.
; Receives:    The memory address of the integer by the stack.
; Returns:     Nothing.
;---------------------------------------------------------------
	PUSH EBP
	MOV  EBP, ESP        
       	
       PUSH DWORD[EBP+8]
       PUSH intInputParameter
       CALL scanf
       ADD  ESP, REMOVE_EIGHT_BYTES 

	MOV  ESP, EBP
	POP  EBP
	RET  CLEAR_INT_PAR

;---------------------------------------------------------------
PRINT_INT:
; Description: Prints an integer entered by the user.
; Receives:    The value of the integer by the stack.
; Returns:     Nothing.
;---------------------------------------------------------------
	PUSH EBP
	MOV  EBP, ESP        
       	
       PUSH DWORD[EBP+8]
       PUSH intOutputParameter
       CALL printf
       ADD  ESP, REMOVE_EIGHT_BYTES 

	MOV  ESP, EBP
	POP  EBP
	RET  CLEAR_INT_PAR
