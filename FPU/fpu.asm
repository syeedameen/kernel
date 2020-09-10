;*******************************************;
;       KERNAL HOST PROTOCALL FOR FLAG      ;
;       REGISTER AND INTERRUPT HANDLER      ;
;*******************************************;
;-------------------------------------------;
;   FPU program utilities for kernal        ;
;       1.program data_segment              ;
;       2.extra segment for data storae     ;
;-------------------------------------------;
;-------------------------------------------;
;   If kernal is ready state for second     ;
;   process skip subroutine for diffrent    ;
;   medium (but CY flag is not clear)       ;
;-------------------------------------------;

UTL:
DATA:               EQU 0X4500 
CODE_ADDRESS:       EQU CS:[0X4500]
COUNTER:            EQU DS:[0X4502]
DPTR1:              EQU DS:[0X4504]
TEMP:               EQU 0X5000

    POP AX      ;POP RET ADD. INTO AX REGISTER 
    POP SI      ;BASE ADDRESS OF ARRAY 
    POP CX      ;COUNTER REGISTER 
    POP DX      ;SEGMENT FLAG REGISTER 
    PUSH AX     ;PUSH RET ADDRESS 

    MOV CODE_ADDRESS,DX 
    MOV DS:[TEMP+2],CX  ;TEMP STORE COUNTER  
    MOV DS:[TEMP+4],CX  
    MOV DS:[TEMP+6],SI  ;TEMP STORE BASE ADDRESS 

    MOV AH,CODE_ADDRESS
    CMP AH,[SI+1]
    JC NOSKIP_UTL       ;SKIP IF NOT EQUAL POINTER REGISTER 
        XCHG AH,[SI+1]
    NOSKIP_UTL:
    INC SI 
    LOOP REPEAT_UTL 
    MOV SI,CODE_ADDRESS
    MOV CX,[TEMP+2]
    DEC [TEMP+4]
    JNZ REPEAT_UTL      ;REPEAT UNTIL [TEMP+4] != 0 
    RET                 ;RETURN SUBROUTINE    

;-----------------------------------------------------;
;           Selection Sort Subroutine                 ;  
;-----------------------------------------------------;
SELSORT:
    POP AX          ;POP RET ADDRESS OF SUBROUTINE 
    POP SI          ;BASE ADDRESS OF ARRAY  
    POP CX          ;COUNTER REGISTER 
    PUSH AX         ;PUSH RET ADDRESS OF ARRAY 

COUNTER:            EQU 0X4500          ;TEMP COUNTER STORE 
BASE_ADDRESS:       EQU 0X4502          ;TEMP BASE ADDRESS STORE 
    
    
    MOV ES:[COUNTER],CX         ;temp counter store
    MOV ES:[COUNTER+2],CX       ;
    MOV ES:[BASE_ADDRESS],SI    ;base address temp store

REPEAT_SELSORT:
    MOV AH,[SI]                 ;move a[i] into ah register
    CMP AH,[SI+1]               ;compare a[i] with a[i+1]
    JC NOSWAP_SELSORT           ;jump if a[i] > [i+1] 
        XCHG AH,[SI+1]          ;exchange registers
    NOSWAP_SELSORT:
    INC SI                      ;inc array index pointer 
    LOOP REPEAT_SELSORT         ;repeat until cx != 0 
    MOV SI,ES:[BASE_ADDRESS]    ;store base address of array 
    MOV CX,ES:[COUNTER]         ;move counter into cx register 
    DEC ES:[COUNTER+2]          ;dec counter register 
    JNZ REPEAT_SELSORT          ;jump until count != 0 
    RET                         ;ret subroutine 