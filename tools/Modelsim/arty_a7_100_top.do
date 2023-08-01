# Create work library
vlib work

# Compile Verilog
vlog ../../src/interfaces/interfaces.sv
vlog ../../src/arty_a7_100_top.sv
vlog ../../testbench/arty_a7_100_top_tb.sv
vlog ../../src/uart_rx.sv
vlog ../../src/uart_tx.sv
vlog ../../src/uart_top.sv
vlog ../../src/blink_1sec.sv

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work arty_a7_100_top_tb



# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do wave/wave_arty_a7_100_top.do


# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End