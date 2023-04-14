onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group dut /uart_top_tb/dut/CLK_PER_BIT
add wave -noupdate -group dut /uart_top_tb/dut/PACK_SIZE
add wave -noupdate -group dut /uart_top_tb/dut/CLK100MHZ
add wave -noupdate -group dut /uart_top_tb/dut/sw
add wave -noupdate -group dut /uart_top_tb/dut/uart_txd_in
add wave -noupdate -group dut /uart_top_tb/dut/uart_rxd_out
add wave -noupdate -group dut /uart_top_tb/dut/LED
add wave -noupdate -group dut /uart_top_tb/dut/reset
add wave -noupdate -group dut /uart_top_tb/dut/strobe_1sec
add wave -noupdate -group dut /uart_top_tb/dut/tx_byte_data
add wave -noupdate -group dut /uart_top_tb/dut/tx_byte_valid
add wave -noupdate -group dut /uart_top_tb/dut/tx_active
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/CLK_PER_BIT
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/PACK_SIZE
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/CLK_INDEX
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/DATA_BITS
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/clk
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/rst
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/tx_byte_valid
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/tx_byte_data
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/tx_bit
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/tx_active
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/tx_done
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/tx_data_cap
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/clk_counter
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/data_index
add wave -noupdate -group uart_tx /uart_top_tb/dut/u_uart_tx0/TX_STATE
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {20 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {226 ps}
