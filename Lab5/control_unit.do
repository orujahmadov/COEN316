add wave *      

# ADDI
force opcode 6'h32
force func_code 000000
run 2


# LW
force opcode 100011
run 2

# ADDi
force opcode 001000
run 2

# BEQ
force opcode 000100
run 2
