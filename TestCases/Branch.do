force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/Interrupt 0 0
run
force -freeze sim:/processor/rst 0 0
force -freeze sim:/processor/inPort 30 0
run
run
run
run
run
run
run
force -freeze sim:/processor/inPort 50 0
run
force -freeze sim:/processor/inPort 100 0
run
force -freeze sim:/processor/inPort 300 0
run
force -freeze sim:/processor/inPort ffffffff 0
run
force -freeze sim:/processor/inPort ffffffff 0
run
run
run
force -freeze sim:/processor/Interrupt 1 0
run
force -freeze sim:/processor/Interrupt 0 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
