// Clock per bit is created using (100000000Hz)/(115200 baud) = 868
// Parameterizable UART data packet size
// PARITY_EN enables the parity bit (1 or 0)
// EVEN_PAR says if even or odd parity (0 odd, 1 even)

module uart_tx_rx #( parameter CLK_PER_BIT = 868, PACK_SIZE = 8, PARITY_EN = 0, EVEN_PAR = 0) (    
    input                           clk,             // input
    input                           rst,             // input
    input                           rx_bit,          // input
    output logic                    rx_byte_valid,   // output
    output logic [PACK_SIZE - 1 :0] rx_byte_data,    // output [PACK_SIZE - 1 :0]
    output logic                    rx_active,       // output
    output logic                    par_error,       // output
    output logic                    stop_error,      // output
    input                           tx_byte_valid,   // input
    input [PACK_SIZE - 1 :0]        tx_byte_data,    // input [PACK_SIZE - 1 :0]
    output logic                    tx_bit,          // output
    output logic                    tx_active,       // output
    output logic                    tx_done          // output
    );

// Instantiate module
uart_rx #(
    .CLK_PER_BIT(CLK_PER_BIT),
    .PACK_SIZE(PACK_SIZE),
    .PARITY_EN(PARITY_EN),
    .EVEN_PAR(EVEN_PAR)
) u_uart_rx0 (
    .clk(clk), 
    .rst(rst),  
    .rx_bit(rx_bit), 
    .rx_byte_valid(rx_byte_valid), 
    .rx_byte_data(rx_byte_data), 
    .rx_active(rx_active),
    .par_error(par_error),
    .stop_error(stop_error)
);

// Instantiate module
uart_tx #(
    .CLK_PER_BIT(CLK_PER_BIT),
    .PACK_SIZE(PACK_SIZE),
    .PARITY_EN(PARITY_EN),
    .EVEN_PAR(EVEN_PAR)
) u_uart_tx0 (
    .clk(clk),
    .rst(rst),
    .tx_byte_valid(tx_byte_valid),
    .tx_byte_data(tx_byte_data),
    .tx_bit(tx_bit),
    .tx_active(tx_active),
    .tx_done(tx_done)
);

endmodule

module uart_tx_rx_tb ();

parameter CLK_PER_BIT = 10;      // Using 10 to cut down sim time
parameter PACK_SIZE   = 8;       // Packet sizes
parameter PACK_DATA   = 8'hFE;   // Set Packet data
parameter PARITY_EN   = 1;       // Sets if parity is enabled
parameter EVEN_PAR    = 0;       // Sets even or odd parity (0 odd, 1 even)

// Define the signals
logic clk;
logic rst;
logic rx_bit;
logic rx_byte_valid;
logic [PACK_SIZE - 1:0] rx_byte_data;
logic rx_active;
logic par_error;
logic stop_error;
logic tx_byte_valid;
logic [PACK_SIZE - 1:0] tx_byte_data;
logic tx_bit;
logic tx_active;
logic tx_done;

// Instantiate module
uart_tx_rx #(
    .CLK_PER_BIT(CLK_PER_BIT),
    .PACK_SIZE(PACK_SIZE),
    .PARITY_EN(PARITY_EN),
    .EVEN_PAR(EVEN_PAR)
) dut (
    .clk(clk),
    .rst(rst),
    .rx_bit(rx_bit),
    .rx_byte_valid(rx_byte_valid),
    .rx_byte_data(rx_byte_data),
    .rx_active(rx_active),
    .par_error(par_error),
    .stop_error(stop_error),
    .tx_byte_valid(tx_byte_valid),
    .tx_byte_data(tx_byte_data),
    .tx_bit(tx_bit),
    .tx_active(tx_active),
    .tx_done(tx_done)
);

// Create loopback of tx to rx
assign rx_bit = tx_bit;

// Create clock signal
initial begin
    clk <= 0; #5;
    forever begin 
        clk <= ~clk; #5;
    end
end

task send_packet;
    // Setup initial data and validate
    input [PACK_SIZE - 1:0] data;
    tx_byte_data  <= data;
    tx_byte_valid <= 1'b1;
    wait(tx_active);
    tx_byte_valid <= 1'b0;
    @(posedge clk);
    wait(tx_done);
    @(posedge clk);
endtask

initial begin
    rst <= 1; tx_byte_valid <= '0; tx_byte_data <= '0;@(posedge clk);
    rst <= 0; @(posedge clk);
    send_packet(PACK_DATA);
    wait(rx_byte_valid);
    if (PACK_DATA == rx_byte_data) begin
        $display("Test Passed!");
    end else begin
        $display("Test Failed!");
    end
    @(posedge clk);
    $stop;
end


endmodule