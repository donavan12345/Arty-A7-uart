module uart_top (
   input CLK100MHZ,
   input [3:0] sw,
   input uart_txd_in,
   output uart_rxd_out,
   output reg [7:0] LED);


parameter CLK_PER_BIT = 868;               // Clock per bit is created using (100000000Hz)/(115200 baud) = 868
parameter PACK_SIZE = 8;                   // Sets number of bits for UART transfer

logic reset;
logic strobe_1sec;

// tx signal set
logic [PACK_SIZE - 1 : 0] tx_byte_data;   // Data packet to send on uart
logic                     tx_byte_valid;  // Valid for tx data packet
logic                     tx_active;      // Shows when a uart tx is sending

// rx signal set
logic [PACK_SIZE - 1 : 0] rx_byte_data;   // Data packet to send on uart
logic                     rx_byte_valid;  // Valid for tx data packet
logic                     rx_active;      // Shows when a uart tx is sending

// Make any switch a reset (Not registered for metastablility)
assign reset = |sw;

// Tie off unused LEDs
assign LED[7:2] = 4'h0;


// Sends a strobe out every second based on 100 MHz clock
blink_1sec #(.CLKMHZ(100)) LED_Blink (
    .clk(CLK100MHZ),
    .rst(reset),
    .strobe(strobe_1sec)
);



// Creates a binary counter out of LEDs[3:0] on board
always_ff @(posedge CLK100MHZ) begin
    if (reset) begin
        LED[1:0] <= 0;
    end else begin
        if (strobe_1sec) begin
            LED[1:0] <= ~LED[1:0];
        end
    end
end

// uart wrapper module
uart_tx_rx #(
    .CLK_PER_BIT(CLK_PER_BIT),
    .PACK_SIZE(PACK_SIZE)
) u_uart_wrapper0 (
    .clk(CLK100MHZ),
    .rst(reset),
    .rx_bit(uart_txd_in),
    .rx_byte_valid(rx_byte_valid),
    .rx_byte_data(rx_byte_data),
    .rx_active(rx_active),
    .tx_byte_valid(tx_byte_valid),
    .tx_byte_data(tx_byte_data),
    .tx_bit(uart_rxd_out),
    .tx_active(tx_active),
    .tx_done()
);

// Create loopback for data form rx
assign tx_byte_valid = rx_byte_valid;
assign tx_byte_data  = rx_byte_data;


endmodule