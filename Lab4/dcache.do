add wave address
add wave din
add wave clk
add wave reset
add wave write

force address "00000"
force din "00000000000000000000000000011111"
force clk "0"
force reset "1"
force write "0"
run 2

force address "00100"
force din "00000000000000001000000000011111"
force clk "0"
force reset "0"
force write "0"
run 2

force address "00011"
force din "00000000100000000000000000011111"
force clk "1"
force reset "0"
force write "1"
run 2

force address "00011"
force din "00000000100000000000000000011111"
force clk "0"
force reset "0"
force write "1"
run 2

force address "10000"
force din "10000000000000010000000000011111"
force clk "1"
force reset "0"
force write "1"
run 2

force address "00011"
force din "00000000100000000000000000011111"
force clk "0"
force reset "0"
force write "1"
run 2

force address "00010"
force din "00000000000000010000000000011011"
force clk "1"
force reset "0"
force write "1"
run 2

force address "00010"
force din "00000000000000010000000000011011"
force clk "1"
force reset "0"
force write "1"
run 2




