	    ORG	    0000h	; Set Program Counter to address 0
START:	MVI	    A,05h	; Multiplier    (-1) to A   Register
	    MVI	    D,08h	; Multiplicand (127) to D,E Registers
	    MVI	    E,000h
	    LXI	    H,000h	; Clear H,L Registers to initialize Partial Product
	    MVI     B,008h	; Iteration Count (8) to B Register
LOOP:	DAD	    H	    ; Shift Partial Product left into Carry (H&L)
	    RAL	    	    ; Rotate Multiplier Byte to Carry
	    JNC	    NEXT	; Test Multiplier at Carry
	    DAD	    D	    ; Add Multiplicand to Partial Product (D&E)
;   if Carry =1
	    ACI	    000h	; (Add Carry Bit)
NEXT:	DCR	    B	    ; Decrement Iteration Counter
        JNZ	    LOOP	; Check Iterations
        SHLD    TOTAL	; Store Answer in Locations 100,101

        HLT		        ; Halt and Catch Fire (HCF)

; Data segment (210 = 0xD2):

	    ORG	040h	; Set Program Counter to address 100 (octal)
TOTAL:	DS	002h	; Reserve 2 bytes (1 word) of uninitialized storage

	    END		    ; End
