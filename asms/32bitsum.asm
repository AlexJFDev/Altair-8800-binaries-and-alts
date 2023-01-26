;  ADF07DB2
; +5E4C8284
;=10C3D0036
;
;      7DB2
;     +8284
;     =0036
;  
;  ADF00000
;  5E4C0000
; +00010000
;=10C3D0000
;
; 10C3D0000
; +00000036
;=10C3D0036

; CODE
        LHLD DW12
        XCHG
        LHLD DW22
        DAD D
        SHLD DWP2
        ACI 00h
        MOV C,A
        LHLD DW11
        XCHG
        LHLD DW21
        DAD D
        DAD B
        SHLD DWP1
        HLT

; DATA
        ORG 0x40h
DW11:   DB 0xF0h ; 24 - 32
        DB 0xADh ; 16 - 23
DW12:   DB 0xB2h ; 0 - 7
        DB 0x7Dh ; 8 - 15

        ORG 0x50h
DW21:   DB 0x4Ch ; 24 - 32
        DB 0x5Eh ; 16 - 23
DW22:   DB 0x84h ; 0 - 7
        DB 0x82h ; 8 - 15

        ORG 0x60h
DWP1:   DS 0x01h ; 24 - 32
        DS 0x01h ; 16 - 23
DWP2:   DS 0x01h ; 0 - 7
        DS 0x01h ; 8 - 15