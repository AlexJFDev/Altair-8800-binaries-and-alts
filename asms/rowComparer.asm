lxi h, 0050h
cmp m 
cc 000bh
inx h 
jmp 0003h
mov d, h 
mov e, l 
ldax d 
ret