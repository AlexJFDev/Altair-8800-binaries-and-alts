; ASCII Characters
CR              EQU     0Dh
LF              EQU     0Ah

; BDOS Functions
BDOS            EQU  05h ; C is instruction, DE is argument
STDOUT          EQU  09h
STDIN           EQU  0Ah


; Data types
; STANDARDSTRING, a string that ends with a $
; BUFFER, an area of memory where the first byte is the length of the buffer, the second byte can be anything, and all other bytes +1 are $

                ORG  0100h

; Program
                ; Get the first number by using the INPUT subroutine
                LXI  D, NUM1PROMPT
                XCHG
                SHLD INPUTPROMPTMSG ; Set INPUTPROMPTMSG argument
                LXI  D, NUMBUFF1
                XCHG
                SHLD INPUTBUFFER ; Set INPUTBUFFER
                LXI  D, NUMVALID
                XCHG
                SHLD INPUTVALIDSTR ; Set INPUTVALIDSTR
                LXI  D, ERRORMSG
                XCHG
                SHLD INPUTERRORMSG ; Set INPUTERRORMSG
                CALL INPUT ; Call Input subroutine
                ; Get the second number
                LXI  D, NUM2PROMPT
                XCHG
                SHLD INPUTPROMPTMSG
                LXI  D, NUMBUFF2
                XCHG
                SHLD INPUTBUFFER
                CALL INPUT
                ; Get the operation
                LXI  D, OPPROMPT
                XCHG
                SHLD INPUTPROMPTMSG
                LXI  D, OPBUFF
                XCHG
                SHLD INPUTBUFFER
                LXI  D, OPVALID
                XCHG
                SHLD INPUTVALIDSTR
                CALL INPUT
                
                LXI B, NUMBUFF1 + 2 ; Convert buffer 1 to int
                CALL PARSEINT
                PUSH H
                LXI B, NUMBUFF2 + 2 ; Convert buffer 2 to int
                CALL PARSEINT
                POP D
                DAD D

                CALL UNPARSE
                LXI  D, UNPARSERETURN
                MVI  C, STDOUT
                CALL BDOS

                RET ; End of program

; Subroutines
; ---INPUT START---
; DESCRIPTION:Prints a prompt message, gets keyboard input, and then validates input
; ARGUMENTS: INPUTPROMPTMSG; location of the string that is printed
;            INPUTBUFFER; location of the buffer where keyboard input is stored, doubles as subroutine return
;            INPUTVALIDSTR; location of the string that the input buffer is checked against
;            INPUTERRORMSG; location of the string that is printed if input is invalid
INPUT           LHLD INPUTPROMPTMSG ; INPUT IO
                XCHG
                MVI  C, STDOUT
                CALL BDOS ; Call STDOUT with INPUTPROMPTMSG as argument
                LHLD INPUTBUFFER
                XCHG
                MVI  C, STDIN 
                CALL BDOS ; Call STDIN with INPUTERRORMSG as argument

                LXI D, NEWLINE
                MVI C, STDOUT
                CALL BDOS ; Prints a new line after input.

                LHLD INPUTVALIDSTR ; Load INPUTVALIDSTR into HL ; INPUT VALIDATION ; Should validate check
                MOV  A, M ; Load first character of INPUTVALIDSTR into A
                CPI  '$' ; Compare first character of INPUTVALIDSTR to $
                RZ ; If the first character of INPUTVALIDSTR is a $ validation can be skipped so return

                XCHG ; Swap INPUTVALIDSTR into DE ; ; Blank input check
                LHLD INPUTBUFFER ; Load INPUTBUFFER into HL
                XCHG ; Swap INPUTVALIDSTR and INPUTBUFFER (DE:INPUTBUFFER, HL:INPUTVALIDSTR)
                INX  D
                INX  D
                LDAX D ; Load third byte (first character) of INPUTBUFFER into A (The first two bytes of a buffer are not characters, they have data about the buffer)
                CPI  '$'
                JZ   INPUTERROR ; If first character of INPUTBUFFER is $ then input was blank and invalid

VALIDLOOP       LDAX D 
                CPI '$'
                RZ ; If the current character of INPUTBUFFER is $ then return succesfully
VALIDSUBLOOP    MVI A, '$'
                CMP M
                JZ INPUTERROR
                LDAX D
                CMP M
                JZ VALIDLOOPEND
                INX  H
                JMP VALIDSUBLOOP
VALIDLOOPEND    LHLD INPUTVALIDSTR
                INX D
                JMP VALIDLOOP

INPUTERROR      LHLD INPUTERRORMSG 
                XCHG
                MVI  C, STDOUT
                CALL BDOS
                LHLD INPUTBUFFER
                MOV  A, M
                INX  H
                INX  H
ERRORLOOP       MVI  M, '$'
                INX  H
                DCR  A
                JNZ  ERRORLOOP
                JMP  INPUT 
; Argument Declarations
INPUTPROMPTMSG  DS   02h ; STANDARDSTRING location
INPUTBUFFER     DS   02h ; BUFFER location
INPUTVALIDSTR   DS   02h ; STANDARDSTRING location, if it is just $ validation will be skipped
INPUTERRORMSG   DS   02h ; STANDARDSTRING location
; ---INPUT END---
; ---PARSEINT START---
; DESCRIPTION: Takes a string location as input and parses it into a 16 bit unsigned integer
; ARGUMENTS: BC, location of string to parse
; RETURN: The 16 bit unsigned integer is in HL registers
PARSEINT        LDAX B ; Load current character to accumulator
                CPI  '$'
                RZ ; Check if current character is $ (end of string)
                LXI  D, 0000h
                XCHG
                DAD  D
                DAD  H
                DAD  H
                DAD  H
                DAD  D
                DAD  D ; The last 8 instructions have the effect of multiplying HL by 10
                SUI  CHARTOINT ; Subtract 30h from accumulator this converts from a character to a number
                MVI  D, 00h
                MOV  E, A ; Move accumulator to DE
                DAD  D ; Add DE (current digit) to HL
                INX  B
                JMP PARSEINT
; Constants:
CHARTOINT       EQU 30h
; ---PARSEINTEND---
; ---UNPARSE START---
; DESCRIPTION: Takes a 16 bit number as input and parses it into a 16 character number
; ARGUMENTS: DE, number to unparse
; RETURN: 16 character number at UNPARSERETURN
;UNPARSE         
UNPARSE         MOV  H, D
                MOV  L, E
                LXI  D, POW16
UNPARSELOOP     DAD  H
                JNC  UNPARSELOOPEND
                XCHG

                LDA  UNPARSERETURN
                ADD  M
                STA  UNPARSERETURN
                INX  H

                LDA  CHAR2
                ADD  M
                CPI  09h
                JNC  CHAR2END
                SUI  0Ah
                DCX  H
                INR  M
                INX  H
CHAR2END        STA  CHAR2
                INX  H

                LDA  CHAR3
                ADD  M
                CPI  09h
                JNC  CHAR3END
                SUI  0Ah
                DCX  H
                INR  M
                INX  H
CHAR3END        STA  CHAR3
                INX  H

                LDA  CHAR4
                ADD  M
                CPI  09h
                JNC  CHAR4END
                SUI  0Ah
                DCX  H
                INR  M
                INX  H
CHAR4END        STA  CHAR4
                INX  H

                LDA  CHAR5
                ADD  M
                CPI  09h
                JNC  CHAR5END
                SUI  0Ah
                DCX  H
                INR  M
                INX  H
CHAR5END        STA  CHAR5
                INX  H

                XCHG
                MOV  A, H
                CPI  00h
                JNZ  UNPARSELOOP
                MOV  A, L
                CPI  00h
                JNZ  UNPARSELOOP
                JMP UNPARSEEND

UNPARSELOOPEND  INX  D
                INX  D
                INX  D
                INX  D
                INX  D
                MOV  A, H
                CPI  00h
                JNZ  UNPARSELOOP
                MOV  A, L
                CPI  00h
                JNZ  UNPARSELOOP
                JMP  UNPARSEEND
UNPARSEEND      LDA  UNPARSERETURN
                ADI  30h
                STA  UNPARSERETURN
                LDA  CHAR2
                ADI  30h
                STA  CHAR2
                LDA  CHAR3
                ADI  30h
                STA  CHAR3
                LDA  CHAR4
                ADI  30h
                STA  CHAR4
                LDA  CHAR5
                ADI  30h
                STA  CHAR5
                RET
                
; RETURNS:
UNPARSEDNUMBER  DS   05h
; Constants:
INTTOCHAR       EQU 30h
POW16           DB  03h, 02h, 07h, 06h, 08h ; 32768
POW15           DB  01h, 06h, 03h, 08h, 04h ; 16384
POW14           DB  00h, 08h, 01h, 09h, 02h ; 08192
POW13           DB  00h, 04h, 00h, 09h, 06h ; 04096
POW12           DB  00h, 02h, 00h, 04h, 08h ; 02048
POW11           DB  00h, 01h, 00h, 02h, 04h ; 01024
POW10           DB  00h, 00h, 05h, 01h, 02h ; 00512
POW9            DB  00h, 00h, 02h, 05h, 06h ; 00256
POW8            DB  00h, 00h, 01h, 02h, 08h ; 00128
POW7            DB  00h, 00h, 00h, 06h, 04h ; 00064
POW6            DB  00h, 00h, 00h, 03h, 02h ; 00032
POW5            DB  00h, 00h, 00h, 01h, 06h ; 00016
POW4            DB  00h, 00h, 00h, 00h, 08h ; 00008
POW3            DB  00h, 00h, 00h, 00h, 04h ; 00004
POW2            DB  00h, 00h, 00h, 00h, 02h ; 00002
POW1            DB  00h, 00h, 00h, 00h, 01h ; 00001

; ---UNPARSE RETURN---
UNPARSERETURN   DS  01h
CHAR2           DS  01h
CHAR3           DS  01h
CHAR4           DS  01h
CHAR5           DS  01h
                DB  '$'

; Text String
NUM1PROMPT      DB   'Enter the first number:', CR, LF, '$'
NUM2PROMPT      DB   'Enter the second number:', CR, LF, '$'
OPPROMPT        DB   'Enter the operation:', CR, LF, '$'
RESULTSTR       DB   'The result is:', CR, LF, '$'
ERRORMSG        DB   'Invalid input please try again.', CR, LF, '$'
NEWLINE         DB   CR, LF, '$'

; Validation Strings
NUMVALID        DB   '1234567890$'
OPVALID         DB   '+-*/$'

; Buffers
NUMBUFF1        DB   05h, 00h
                DB   '$$$$$$$$$$$$$$$$$'
NUMBUFF2        DB   05h, 00h
                DB   '$$$$$$$$$$$$$$$$$'
OPBUFF          DB   01h, 00h
                DB   '$$'
                END
; Buffer Organization
; Byte   :  Value
; 1      :  len
; 2      :  00
; 3->len :  $
