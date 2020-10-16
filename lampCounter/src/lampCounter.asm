;used in string handling
%DEFINE LINE_FEED           0x0A
%DEFINE END_OF_STRING       0x0
%DEFINE CARRIAGE_RETURN     0x0D

;used to exit the aplication
%DEFINE EXIT_PROGRAMM      -1

;used in stack handling
%DEFINE REMOVE_FOUR_BYTES   4
%DEFINE REMOVE_EIGHT_BYTES  8
%DEFINE REMOVE_TWELVE_BYTES 12

;used in the print procedure
%DEFINE PRINT_STRING        0
%DEFINE PRINT_DOUBLE        1

;used in the scan procedure
%DEFINE SCAN_INT            0
%DEFINE SCAN_DOUBLE         1

;used in to check (IS OPERAND < 0 ?)
%DEFINE ERROR_CHECK         0

;used to check the type of the room
%DEFINE ROOM_TYPE_0         0
%DEFINE ROOM_TYPE_1         1
%DEFINE ROOM_TYPE_2         2
%DEFINE ROOM_TYPE_3         3
%DEFINE ROOM_TYPE_4         4

;based in room type
%DEFINE POTENCY_TYPE_0      12
%DEFINE POTENCY_TYPE_1      15
%DEFINE POTENCY_TYPE_2      18
%DEFINE POTENCY_TYPE_3      20
%DEFINE POTENCY_TYPE_4      22

;external procedures
EXTERN printf
EXTERN scanf

SECTION .data
defaultPotency              DD 60
intInput                    DB "%d",             END_OF_STRING
doubleInput                 DB "%f",             END_OF_STRING
doubleOutput                DB "%lf",            CARRIAGE_RETURN, LINE_FEED, END_OF_STRING
exceededLimitErrorMessage   DB "Valor Invalido", CARRIAGE_RETURN, LINE_FEED, END_OF_STRING

SECTION .bss
roomType        RESD 1
roomWidth       RESD 1
roomLength      RESD 1
requiredPotency RESD 1
lampQuant       RESQ 1

SECTION .text
GLOBAL main
main:
    ;the stack frame is created
    PUSH EBP
    MOV  EBP, ESP

init_main:
    ;get the data (int) from the user
    MOV  EAX, roomType
    MOV  EBX, SCAN_INT
    CALL INPUT_INTERFACE
    
    ;check which potency is required OR terminate if -1
    MOV EAX, [roomType]
    CALL ROOM_VERIFY
    
    ;get the data (float) from the user
    MOV  EAX, roomWidth
    MOV  EBX, SCAN_DOUBLE
    CALL INPUT_INTERFACE  
    
    ;check if the value is ate least greater then zero
    MOV  EAX, [roomWidth]
    CALL SIZE_ERROR_CHECK
    
    ;get the data (float) from the user
    MOV  EAX, roomLength
    MOV  EBX, SCAN_DOUBLE
    CALL INPUT_INTERFACE 
    
    ;check if the value is ate least greater then zero
    MOV  EAX, [roomLength]
    CALL SIZE_ERROR_CHECK
    
    ;calculates the required amount of lamps
    CALL LAMP_CALC

    ;then prints it (float) in the screen
    MOV  EAX, lampQuant
    MOV  EBX, PRINT_DOUBLE
    CALL OUTPUT_INTERFACE
    
    ;loop until roomType = -1
    JMP init_main

end_main:
    ;the stack frame is removed
    MOV  ESP, EBP
    POP  EBP
    ;return 0 to main procecure
    XOR  EAX, EAX
    RET

;---------------------------------------------------------------------    
LAMP_CALC:
; Description: Calculates the number of 60 watt lamps needed for a
;              type of room of certain length and width.
; Receives:    Nothing, despite the fact that the values for "length",  
;              "width" and "potency required" must already be in memory  
;              (assuming the "default potency" value for the lamps is 
;              already in place from the beginning).
; Returns:     Nothing, although, after the procedure, the final value
;              will be in position, in the memory (at "lampQuant").
;---------------------------------------------------------------------
    PUSH EBP
    MOV EBP, ESP
    
    ;start FPU
    FINIT
    ;load roomLength in the FPU 'stack'
    FLD  DWORD[roomLength]
    ;load roomWidth in the FPU 'stack'
    FLD  DWORD[roomWidth]
    ;multiplies the first two elements of the stack (area)
    FMUL ST0, ST1
    ;multiplies the area for the required potency 
    FIMUL DWORD[requiredPotency]
    ;then divides it by 60
    FIDIV DWORD[defaultPotency]
    ;save the final value in memory then pop from 'stack'
    FSTP QWORD[lampQuant]
    
    MOV ESP, EBP
    POP EBP
    RET

;---------------------------------------------------------------------    
ROOM_VERIFY:
; Description: It assimilates a value of a "required power" for a 
;              certain type of room (0 to 4), or for the program
;              (-1 or >4).
; Receives:    EAX with the type of the room.
; Returns:     Nothing, although, after the procedure, the final value
;              will be in position, in the memory(at "requiredPotency"),
;              or not, depending if the entry is beetween 0 and 4, if
;              not, the programm ends.
;---------------------------------------------------------------------
    PUSH EBP
    MOV  EBP, ESP
    
    ;check if the room type the user typed
    ;is -1, if so, terminate the program
    CMP EAX, EXIT_PROGRAMM
    JE  EXIT_PROGRAMM_COMMAND
    
    ;check if the room type the user typed
    ;is from 0 to 4, if above, display a 
    ;error message
    CMP EAX, ROOM_TYPE_0
    JE  ROOM_VERIFY_type_0
    
    CMP EAX, ROOM_TYPE_1
    JE  ROOM_VERIFY_type_1
    
    CMP EAX, ROOM_TYPE_2
    JE  ROOM_VERIFY_type_2
    
    CMP EAX, ROOM_TYPE_3
    JE  ROOM_VERIFY_type_3
    
    CMP EAX, ROOM_TYPE_4
    JE  ROOM_VERIFY_type_4
    
    JMP DISPLAY_ERROR_MESSAGE

end_ROOM_VERIFY:   
    MOV ESP, EBP
    POP EBP
    RET
    
    ;move to memory the potency value then returns
ROOM_VERIFY_type_0:
    MOV BYTE[requiredPotency], POTENCY_TYPE_0
    JMP end_ROOM_VERIFY

ROOM_VERIFY_type_1:
    MOV BYTE[requiredPotency], POTENCY_TYPE_1
    JMP end_ROOM_VERIFY

ROOM_VERIFY_type_2:
    MOV BYTE[requiredPotency], POTENCY_TYPE_2
    JMP end_ROOM_VERIFY

ROOM_VERIFY_type_3:
    MOV BYTE[requiredPotency], POTENCY_TYPE_3
    JMP end_ROOM_VERIFY
    
ROOM_VERIFY_type_4:
    MOV BYTE[requiredPotency], POTENCY_TYPE_4 
    JMP end_ROOM_VERIFY
    
EXIT_PROGRAMM_COMMAND:   
    MOV ESP, EBP
    POP EBP
    ;jump to the end of the program
    JMP end_main
    
;---------------------------------------------------------------------    
INPUT_INTERFACE:
; Description: Scan from the user a integer or a double.
; Receives:    EAX with the address of the memory with the reserved 
;              space you want to fill, and EBX with 0 to scan a int 
;              or 1 for double.
; Returns:     Nothing.
;---------------------------------------------------------------------
    PUSH EBP
    MOV EBP, ESP
    
    ;check the EBX control value
    CMP EBX, SCAN_DOUBLE
    JE  double_INPUT_INTERFACE
    
    ;scan a integer
int_INPUT_INTERFACE:    
    PUSH EAX
    PUSH intInput
    CALL scanf
    ADD  ESP, REMOVE_EIGHT_BYTES
    JMP  end_INPUT_INTERFACE
    
    ;scan a double
double_INPUT_INTERFACE:    
    PUSH EAX
    PUSH doubleInput
    CALL scanf
    ADD  ESP, REMOVE_EIGHT_BYTES

end_INPUT_INTERFACE:    
    MOV  ESP, EBP
    POP  EBP
    RET 
    
;---------------------------------------------------------------------    
OUTPUT_INTERFACE:
; Description: Print in the screen a string or a double.
; Receives:    EAX with the address of the memory with what you want 
;              to print, and EBX with 0 to print a string or 1 for 
;              double.
; Returns:     Nothing.
;---------------------------------------------------------------------
    PUSH EBP
    MOV EBP, ESP
    
    ;check the EBX control value
    CMP EBX, PRINT_DOUBLE
    JE  double_OUTPUT_INTERFACE
    
    ;print a string
string_OUTPUT_INTERFACE:    
    PUSH EAX
    CALL printf
    ADD  ESP, REMOVE_FOUR_BYTES
    JMP  end_OUTPUT_INTERFACE

    ;print a double
double_OUTPUT_INTERFACE:     
    PUSH DWORD[EAX+4]
    PUSH DWORD[EAX]
    PUSH doubleOutput
    CALL printf
    ADD  ESP, REMOVE_TWELVE_BYTES

end_OUTPUT_INTERFACE:  
    MOV ESP, EBP
    POP EBP
    RET     
    
;---------------------------------------------------------------------    
SIZE_ERROR_CHECK:
; Description: Checks whether the value in EAX is greater than 0. If 
;              not, print an error message and terminate the program.
; Receives:    EAX with the value to be tested.
; Returns:     Nothing.
;---------------------------------------------------------------------   
    PUSH EBP
    MOV EBP, ESP
    
    ;check if the value is at least greater than 0
    CMP EAX, ERROR_CHECK
       
    JG end_SIZE_ERROR_CHECK   

    ;if not, display error message
DISPLAY_ERROR_MESSAGE:          
    MOV  EAX, exceededLimitErrorMessage
    MOV  EBX, PRINT_STRING
    CALL OUTPUT_INTERFACE
    ;exit the programm    
    JMP EXIT_PROGRAMM_COMMAND

end_SIZE_ERROR_CHECK:  
    MOV ESP, EBP
    POP EBP
    RET       
