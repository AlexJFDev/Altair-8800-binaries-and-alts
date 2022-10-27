; CODE
        LDA X
        LHLD YADDR
        XCHG 
        LHLD XADDR
LOOP:   INR C
        MOV B,A
        MOV A,C
        XCHG
        CMP M
        JZ END
        MOV A,B
        XCHG
        ADD M
        JMP LOOP
END:    JMP END
; DATA
X:      DB 20h
Y:      DB 03h
        NOP
XADDR:  DB 001bh
        NOP
YADDR:  DB 001ch