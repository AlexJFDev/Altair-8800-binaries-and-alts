        JMP START
OUT:    DB 00h
LOC:    DB 00h
        DB 00h
START:  MVI c, 10h
        LXI h, 0050h
        MOV d,h
        MOV e,l
        DCX h
        JMP LOOP
END:    LDAX d
        STA OUT
        XCHG
        SHLD LOC
STOP:   JMP STOP
COMP:   INX h
        LDAX d
        cmp m
        RNC
        MOV d, h
        MOV e, l
        RET
LOOP:   MOV a, b
        CMP c
        JZ END
        INR b
        CALL COMP
        JMP LOOP
