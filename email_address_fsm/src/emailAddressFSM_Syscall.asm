;just some macros to help understand the code 
%DEFINE LINE_FEED           0x0A
%DEFINE END_OF_STRING       0x0
%DEFINE CARRIAGE_RETURN     0x0D
%DEFINE REMOVE_FOUR_BYTES   4
%DEFINE REMOVE_FIVE_BYTES   5
%DEFINE REMOVE_EIGHT_BYTES  8
%DEFINE MAX_SIZE_STRING     50
%DEFINE ERROR_CHECK         0
%DEFINE SYSCALL_READ        3
%DEFINE STD_OUT             1
%DEFINE GET_ONE_BYTE        1
%DEFINE CALL_KERNEL         1

;external procedures
EXTERN printf
EXTERN scanf

SECTION .data
charInput                   DB "%c",       END_OF_STRING
validAddressMessage         DB "Valido",   CARRIAGE_RETURN, LINE_FEED, END_OF_STRING
invalidAddressMessage       DB "Invalido", CARRIAGE_RETURN, LINE_FEED, END_OF_STRING

SECTION .bss
;temporary-data buffer to keep the user's chars 
inputBuffer  RESB 1
;a string with 50 bytes to keep the email address
emailAddress RESB MAX_SIZE_STRING

SECTION .text
GLOBAL main
main:
    PUSH EBP
    MOV  EBP, ESP
      
    ;put the address where the full email
    ;will be located in ESI
    MOV ESI, emailAddress

;will verify the first input
;if it is not a lowercase letter of the 
;alphabet it shows the error message and 
;exits the program            
STATE_A:
    ;get a char from the terminal
    ;and saves it in the memory
    CALL GET_NEXT_INPUT
    ;checks if it is a lowercase letter
    CALL IS_LETTER
    ;if so, then go to state b
    JZ   STATE_B 
    ;if it isn't, then dsplay a error message
    ;and exit
    MOV EAX, invalidAddressMessage
    CALL DISPLAY_MESSAGE  
    JMP  end_main
    
;from here on it is checked from the second input 
;ahead
;if it is a lowercase letter of the 
;alphabet then loop
;if it is a 'at' then go to the C state
;if it is none of the above it shows the 
;error message and exits the program    
STATE_B:
    CALL GET_NEXT_INPUT
    CALL IS_LETTER
    JZ   STATE_B
    CALL IS_AT_CHAR
    JZ   STATE_C     
    MOV EAX, invalidAddressMessage
    CALL DISPLAY_MESSAGE  
    JMP  end_main
    
;if it is a lowercase letter of the 
;alphabet then loop
;if it is a 'dot' then go to the D state
;if it is none of the above it shows the 
;error message and exits the program
STATE_C:
    CALL GET_NEXT_INPUT
    CALL IS_LETTER
    JZ   STATE_C
    CALL IS_DOT_CHAR
    JZ   STATE_D     
    MOV EAX, invalidAddressMessage
    CALL DISPLAY_MESSAGE  
    JMP  end_main

;this one it's only to the dots
;if it is a lowercase letter of the 
;alphabet then go to E
;if not, then prints the error and exits
STATE_D:
    CALL GET_NEXT_INPUT
    CALL IS_LETTER
    JZ   STATE_E       
    MOV EAX, invalidAddressMessage
    CALL DISPLAY_MESSAGE  
    JMP  end_main

;if it is a lowercase letter of the 
;alphabet then loop
;if it is a 'dot' then go to the D state
;if it is none of the above it shows the 
;valid message and exits the program        
STATE_E:
    CALL GET_NEXT_INPUT
    CALL IS_LETTER
    JZ   STATE_E
    CALL IS_DOT_CHAR
    JZ   STATE_D 
    MOV EAX, validAddressMessage
    CALL DISPLAY_MESSAGE  
    
    ;it would print the complete address
    ;to see it, just remove the commentaries 
    ;MOV EAX, emailAddress
    ;CALL DISPLAY_MESSAGE
    
end_main:
    MOV  ESP, EBP
    POP  EBP
    XOR  EAX, EAX
    RET

;----------------------------------------------------------------        
GET_NEXT_INPUT:   
; Description: Takes the next character typed by the user, places
;              it in AL and in the memory(full email address).
; Receives:    Nothing.
; Returns:     AL with the user's input.
;----------------------------------------------------------------
    PUSH EBP
    MOV EBP, ESP
    
    ;gets the input to the buffer
    MOV EAX, SYSCALL_READ
    MOV EBX, STD_OUT
    MOV ECX, inputBuffer
    MOV EDX, GET_ONE_BYTE
    INT CALL_KERNEL
    
    ;save the char in the memory
    MOV AL, [inputBuffer]
    ;ESI = emailAddress
    MOV [ESI], AL
    INC ESI
    
    MOV ESP, EBP
    POP EBP
    RET
    
;----------------------------------------------------------------        
IS_LETTER:   
; Description: Checks if the user's input is a lowercase letter of
;              the alphabet.
; Receives:    AL with the user's input.
; Returns:     ZF = 1 if it's a lowercase letter.
;----------------------------------------------------------------
    PUSH EBP
    MOV EBP, ESP
    
    ;chek if the char is beetwen 'a' and 'z'
    CMP  AL, 'a'  
    JB   end_IS_LETTER
    CMP  AL, 'z'  
    JA   end_IS_LETTER
    TEST AL, ERROR_CHECK
    
 end_IS_LETTER:  
    MOV ESP, EBP
    POP EBP
    RET    

;----------------------------------------------------------------        
IS_AT_CHAR:   
; Description: Checks if the user's input is a '@'.
; Receives:    AL with the user's input.
; Returns:     ZF = 1 if it's a '@'.
;----------------------------------------------------------------
    PUSH EBP
    MOV EBP, ESP

    CMP  AL, '@'  
    JNZ  end_IS_AT_CHAR
    TEST AL, ERROR_CHECK
    
 end_IS_AT_CHAR:  
    MOV ESP, EBP
    POP EBP
    RET 

;----------------------------------------------------------------        
IS_DOT_CHAR:   
; Description: Checks if the user's input is a '.'.
; Receives:    AL with the user's input.
; Returns:     ZF = 1 if it's a '.'.
;----------------------------------------------------------------
    PUSH EBP
    MOV EBP, ESP

    CMP  AL, '.'  
    JNZ  end_IS_DOT_CHAR
    TEST AL, ERROR_CHECK
    
 end_IS_DOT_CHAR:  
    MOV ESP, EBP
    POP EBP
    RET
    
;----------------------------------------------------------------        
DISPLAY_MESSAGE:   
; Description: Display a message in the screen.
; Receives:    EAX with the address of the message.
; Returns:     Nothing.
;----------------------------------------------------------------
    PUSH EBP
    MOV EBP, ESP

    PUSH EAX
    CALL printf
    ADD ESP, REMOVE_FOUR_BYTES
    
    MOV ESP, EBP
    POP EBP
    RET                 