add wave func_code
add wave opcode


# ADD
force func_code "100000"
force opcode "000000"
run 2

# AND
force func_code "100100"
force opcode "000000"
run 2

# LW
force func_code "000000"
force opcode "100011"
run 2

# ADDi
force func_code "000000"
force opcode "001000"
run 2

# BEQ
force func_code "000000"
force opcode "000100"
run 2
