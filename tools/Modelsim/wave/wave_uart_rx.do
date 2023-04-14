onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group tb_top /uart_rx_tb/clk
add wave -noupdate -group tb_top /uart_rx_tb/rst
add wave -noupdate -group tb_top /uart_rx_tb/rx_bit
add wave -noupdate -group tb_top /uart_rx_tb/rx_byte_valid
add wave -noupdate -group tb_top /uart_rx_tb/rx_byte_data
add wave -noupdate -group tb_top /uart_rx_tb/rx_active
add wave -noupdate -group tb_top /uart_rx_tb/rx_done
add wave -noupdate -group dut /uart_rx_tb/dut/CLK_PER_BIT
add wave -noupdate -group dut /uart_rx_tb/dut/PACK_SIZE
add wave -noupdate -group dut /uart_rx_tb/dut/CLK_INDEX
add wave -noupdate -group dut /uart_rx_tb/dut/DATA_BITS
add wave -noupdate -group dut /uart_rx_tb/dut/clk
add wave -noupdate -group dut /uart_rx_tb/dut/rst
add wave -noupdate -group dut /uart_rx_tb/dut/rx_bit
add wave -noupdate -group dut /uart_rx_tb/dut/rx_byte_valid
add wave -noupdate -group dut /uart_rx_tb/dut/rx_byte_data
add wave -noupdate -group dut /uart_rx_tb/dut/rx_active
add wave -noupdate -group dut /uart_rx_tb/dut/RX_STATE
add wave -noupdate -group dut /uart_rx_tb/dut/clk_counter
add wave -noupdate -group dut /uart_rx_tb/dut/data_index
add wave -noupdate -group dut /uart_rx_tb/dut/rx_bit_r0
add wave -noupdate -group dut /uart_rx_tb/dut/rx_bit_r1
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {1 ns}
