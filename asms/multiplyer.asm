; CODE
        ORG 0h
        LDA X
        LHLD YADDR
        INR D
        MOV C,A
LOOP:   MOV B,A
        MOV A,D
        CMP M
        JZ END
        INR D
        MOV A,B
        ADD C
        JMP LOOP
END:    JMP END
; DATA
;        ORG 00f0h
X:      DB 08h
Y:      DB 08h
YADDR:  DB 0017h
        NOP