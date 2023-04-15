onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group tb_top /arty_a7_100_top_tb/clk
add wave -noupdate -group tb_top /arty_a7_100_top_tb/sw
add wave -noupdate -group tb_top /arty_a7_100_top_tb/uart_txd_in
add wave -noupdate -group tb_top /arty_a7_100_top_tb/uart_rxd_out
add wave -noupdate -group tb_top /arty_a7_100_top_tb/LED
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/CLK_PER_BIT
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/PACK_SIZE
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/PARITY_EN
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/EVEN_PAR
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/CLK100MHZ
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/sw
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/uart_txd_in
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/uart_rxd_out
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/LED
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/reset
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/strobe_1sec
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/tx_byte_data
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/tx_byte_valid
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/tx_active
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/rx_byte_data
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/rx_byte_valid
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/rx_active
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/par_error
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/stop_error
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/par_error_flag
add wave -noupdate -group arty_top /arty_a7_100_top_tb/dut/stop_error_flag
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
