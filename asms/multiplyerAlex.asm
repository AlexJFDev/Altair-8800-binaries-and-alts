; Program
        MVI E, 20h ; Load X to E register
        MVI L, 03h ; Load Y to L register
        MOV A, E
        CMP L
        MOV E,A ; Copy X to the E register
        LDA Y ; Load Y to accumulator, program will loop Y times.
LOOP:   DAD D ; Add D,E to H,L
        DCR A ; Decrement B
        JNZ Loop ; Jump to beginning of loop if A != 0
        SHLD Out ; Store the product
END:    JMP END
; DATA
X:      DB 20h ; 32
Y:      DB 03h ; 3
Out:    DB 0000h