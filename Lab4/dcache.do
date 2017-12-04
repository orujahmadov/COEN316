# do file to test the dcache
add wave *


# reset
force address 5'b00000
force din 32'b00000000000000000000000000000000
force data_write 0
force reset 1
force clk 0

run 5

# data read
force address 5'b00010
force din 32'b00000000000000000000000000000000
force data_write 0
force reset 0
force clk 1

run 5

force clk 0
run 5

# data write
force address 5'b01010
force din 32'b00000000000000000000000000000010
force data_write 1
force reset 0
force clk 1

run 5

force clk 0
run 5

# data write
force address 5'b00100
force din 32'b00000100000000000000000000000010
force data_write 1
force reset 0
force clk 1

run 5

force clk 0
run 5

# data write
force address 5'b10010
force din 32'b00000000000000000110000000000010
force data_write 1
force reset 0
force clk 1

run 5

force clk 0
run 5

# data read
force address 5'b01010
force din 32'b00000000000000000000000000000000
force data_write 0
force reset 0
force clk 1

run 5

# reset
force address 5'b00000
force din 32'b00000000000000000000000000000000
force data_write 0
force reset 1
force clk 0

run 5

# data read
force address 5'b01010
force din 32'b00000000000000000000000000000000
force data_write 0
force reset 0
force clk 1

run 5


