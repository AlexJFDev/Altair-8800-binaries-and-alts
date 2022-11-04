; CODE
        LDA Y
        MOV B,A
        LDA X
        MOV E,A
LOOP:   DAD D
        DCR B
        JZ END
        JMP LOOP
END:    JMP END
; DATA
X:      DB 20h
Y:      DB 03h