onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group tb_top /uart_top_tb/CLK_PER_BIT
add wave -noupdate -group tb_top /uart_top_tb/PACK_SIZE
add wave -noupdate -group tb_top /uart_top_tb/PACK_DATA
add wave -noupdate -group tb_top /uart_top_tb/clk
add wave -noupdate -group tb_top /uart_top_tb/rst
add wave -noupdate -group tb_top /uart_top_tb/rx_bit
add wave -noupdate -group tb_top /uart_top_tb/rx_byte_valid
add wave -noupdate -group tb_top /uart_top_tb/rx_byte_data
add wave -noupdate -group tb_top /uart_top_tb/rx_active
add wave -noupdate -group tb_top /uart_top_tb/tx_byte_valid
add wave -noupdate -group tb_top /uart_top_tb/tx_byte_data
add wave -noupdate -group tb_top /uart_top_tb/tx_bit
add wave -noupdate -group tb_top /uart_top_tb/tx_active
add wave -noupdate -group tb_top /uart_top_tb/tx_done
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/CLK_PER_BIT
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/PACK_SIZE
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/CLK_INDEX
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/DATA_BITS
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/clk
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/rst
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/rx_bit
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/rx_byte_valid
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/rx_byte_data
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/rx_active
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/RX_STATE
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/clk_counter
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/data_index
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/rx_bit_r0
add wave -noupdate -group uart_rx /uart_top_tb/dut/u_uart_rx0/rx_bit_r1
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
