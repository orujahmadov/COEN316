add wave immediate_field
add wave func

force func "00"
force immediate_field "0000000000011111"
run 2

force func "10"
run 2
force immediate_field "0000000000011111"
run 2

force immediate_field "1000010000011111"
run 2

force func "11"
run 2
force immediate_field "1000010000011111"
run 2

force func "10"
run 2
force immediate_field "0000000000011111"
run 2

force immediate_field "1000010000011111"
run 2

force func "11"
run 2
force immediate_field "1000010000011111"
run 2
