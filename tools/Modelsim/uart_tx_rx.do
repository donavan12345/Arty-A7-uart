# Create work library
vlib work

# Compile Verilog
vlog ../../src/uart_rx.sv
vlog ../../src/uart_tx.sv
vlog ../../src/uart_tx_rx.sv

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work uart_tx_rx_tb



# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do wave/wave_uart_tx_rx.do


# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End