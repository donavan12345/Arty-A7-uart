onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /uart_tx_tb/CLK_PER_BIT
add wave -noupdate /uart_tx_tb/PACK_SIZE
add wave -noupdate /uart_tx_tb/clk
add wave -noupdate /uart_tx_tb/rst
add wave -noupdate /uart_tx_tb/tx_byte_valid
add wave -noupdate /uart_tx_tb/tx_byte_data
add wave -noupdate /uart_tx_tb/tx_bit
add wave -noupdate /uart_tx_tb/tx_active
add wave -noupdate /uart_tx_tb/tx_done
add wave -noupdate /uart_tx_tb/dut/TX_STATE
add wave -noupdate /uart_tx_tb/dut/data_index
add wave -noupdate /uart_tx_tb/dut/clk_counter
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {18351927 ps} 0}
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
WaveRestoreZoom {15121385 ps} {15121631 ps}
