force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/Interrupt 0 0
run
force -freeze sim:/processor/rst 0 0
force -freeze sim:/processor/inPort 5 0
run
run
run
force -freeze sim:/processor/inPort 00000019 0
run
force -freeze sim:/processor/inPort 0000fffd 0
run
force -freeze sim:/processor/inPort f320 0
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

