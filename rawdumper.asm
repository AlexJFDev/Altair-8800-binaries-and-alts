; ASCII Characters
CR              EQU     0Dh
LF              EQU     0Ah

; BDOS Functions
BDOS            EQU  05h ; C is instruction, DE is argument
STDOUT          EQU  09h

; This program prints the contents of memory. It is meant to be used as a subroutine.

                ORG  0100h

DUMPER          PUSH A
                PUSH B
                PUSH D
                PUSH H ; Backup State

                LXI  D, LINEONE
                MVI  C, STDOUT
                CALL BDOS ; Print out the first line

                LXI  D, 0000h ; Position in memory
                LXI  H, MEMORIES ; Sets row to 0

DUMPERLOOP      PUSH A ; Backup A (loop position)
                MOV  A, M ; Move HL pointer to A
                STA  OUTLINE + 2 ; Store A in the 3rd collumn of the output line
                INX  H
                MOV  A, M
                STA  OUTLINE + 3 ; Store A in the 4th coullumn
                INX  H ; The previous section basically sets the row number in collumns 3 & 4

                PUSH H ; Backup HL

                LXI  B, OUTLINE
                MVI  C, 05h
DUMPERSUBLOOP   INX  B
                LXI  H, MEMORIES ; Load memory table
                LDAX D ; Load memory in DE
                ADD  A ; Double it
                MOV  L, A ; Move memory to L
                MOV  A, H
                ACI  00h
                MOV  H, A ; Increase H by 1 if needed
                MOV  A, M ; Move M to A
                STAX B ; Store in outline
                INX  B ; Increment outline pos
                INX  H
                MOV  A, M
                STAX B ; Store in outline
                INX  B ; Increment outline pos
                INX  D
                MOV  A, C
                CPI  35h
                JNZ  DUMPERSUBLOOP

                PUSH D ; Backup DE before BDOS
                
                LXI  D, OUTLINE
                MVI  C, STDOUT
                CALL BDOS

                POP  D
                POP  H
                POP  A ; Reload AF, DE, & HL
                INR  A
                CPI  00h
                JNZ  DUMPERLOOP

                POP  H
                POP  D
                POP  B
                POP  A
                RET

                

LINEONE         DB   '      00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F', CR, LF, '$'
                ORG  0200h
OUTLINE         DB   '00000:00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00', CR, LF, '$'

                ORG  0300h ; For the memory table to work it must start at a multiple of 100 (hex)
MEMORIES        DB   '000102030405060708090A0B0C0D0E0F'
                DB   '101112131415161718191A1B1C1D1E1F'
                DB   '202122232425262728292A2B2C2D2E2F'
                DB   '303132333435363738393A3B3C3D3E3F'
                DB   '404142434445464748494A4B4C4D4E4F'
                DB   '505152535455565758595A5B5C5D5E5F'
                DB   '606162636465666768696A6B6C6D6E6F'
                DB   '707172737475767778797A7B7C7D7E7F'
                DB   '808182838485868788898A8B8C8D8E8F'
                DB   '909192939495969798999A9B9C9D9E9F'
                DB   'A0A1A2A3A4A5A6A7A8A9AAABACADAEAF'
                DB   'B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF'
                DB   'C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF'
                DB   'D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF'
                DB   'E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF'
                DB   'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'
