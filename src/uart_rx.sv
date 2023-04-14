// Hevaily inspired by nandland at https://nandland.com/uart-serial-port-module/

// Clock per bit is created using (100000000Hz)/(115200 baud) = 868
// Parameterizable UART data packet size
module uart_rx #( parameter CLK_PER_BIT = 868, PACK_SIZE = 8) (
    input                           clk,             // input
    input                           rst,             // input
    input                           rx_bit,          // input
    output logic                    rx_byte_valid,   // output
    output logic [PACK_SIZE - 1 :0] rx_byte_data,    // output [PACK_SIZE - 1 :0]
    output logic                    rx_active       // output
);

parameter CLK_INDEX = $clog2(CLK_PER_BIT); // Number of bits to keep track of clock cycles
parameter DATA_BITS = $clog2(PACK_SIZE);   // Number of bits to keep track of data index

enum {IDLE, START, DATA, STOP} RX_STATE;

logic [CLK_INDEX - 1 : 0] clk_counter; // Keep track of clock cycles to match baud rate
logic [DATA_BITS - 1 : 0] data_index;  // Track rx bits into byte buffer
logic                     rx_bit_r0, rx_bit_r1;    // registered version of rx_bit for metastability

// Double register input to clear metastablility errors
always_ff @(posedge clk) begin
    if (rst) begin
        rx_bit_r0 <= '0;
        rx_bit_r1 <= '0;
    end else begin
        rx_bit_r0 <= rx_bit;
        rx_bit_r1 <= rx_bit_r0;
    end
end

always_ff @(posedge clk) begin
    case(RX_STATE)

        // IDLE:  Wait for rx_bit to go low
        IDLE: begin
            // Set all signals to initial state
            clk_counter   <= '0;
            data_index    <= '0;
            rx_byte_valid <= '0;
            rx_active     <= '0;

            // If rx bit goes low then move to start state
            if (!rx_bit_r1) begin
                RX_STATE <= START;
                rx_active <= 1'b1;
            end
        end

        // START: Check start bit at half way through clock counts
        START: begin
            // Check bit value at the halfway point in the data transfer
            if (clk_counter > (CLK_PER_BIT/2 - 1)) begin
                // If start bit went back high there was a start issue
                // and go back to IDLE
                if (rx_bit_r1) begin
                    RX_STATE <= IDLE;
                end else begin
                    RX_STATE    <= DATA;
                end
                clk_counter <= '0;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end

        // DATA:  Wait one set of cycles and get each data bit
        DATA: begin
            // Every clk set add new bit to data byte
            if (clk_counter > CLK_PER_BIT - 1) begin
                rx_byte_data[data_index] <= rx_bit_r1;
                data_index               <= data_index + 1;
                clk_counter              <= 0;
                // Once all bits are filled move to get stop bit
                if (data_index == PACK_SIZE - 1) begin
                    RX_STATE <= STOP;
                end
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end

        // STOP:  Check stop bit is valid then exit
        STOP: begin
            // Wait for final bit and then go back to IDLE
            if (clk_counter > CLK_PER_BIT - 1) begin
                RX_STATE <= IDLE;
                // If Stop bit is high then data is valid
                // If stop bit is low then there was an error so
                // data is not valid
                if(rx_bit_r1) begin
                    rx_byte_valid <= 1'b1;
                end else begin
                    rx_byte_valid <= 1'b0;
                end
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end

        // Default to IDLE state
        default:
            RX_STATE <= IDLE;
    endcase
end
endmodule


module uart_rx_tb();

parameter CLK_PER_BIT = 10;    // Using 10 to cut down sim time
parameter PACK_SIZE   = 8;     // Packet sizes
parameter PACK_DATA   = 8'hFE; // Set Packet data

// Define the signals
logic clk;
logic rst;
logic rx_bit;
logic rx_byte_valid;
logic [PACK_SIZE - 1:0] rx_byte_data;
logic rx_active;

// Instantiate module
uart_rx #(
    .CLK_PER_BIT(CLK_PER_BIT),
    .PACK_SIZE(PACK_SIZE)
) dut (
    .clk(clk),                       // Input
    .rst(rst),                       // Input
    .rx_bit(rx_bit),                 // Input
    .rx_byte_valid(rx_byte_valid),   // Output
    .rx_byte_data(rx_byte_data),     // Output
    .rx_active(rx_active)            //Output
);

// Create clock signal
initial begin
    clk <= 0; #5;
    forever begin 
        clk <= ~clk; #5;
    end
end

task recieve_packet;
    // Setup initial data and validate
    input [PACK_SIZE - 1:0] data;

    logic [PACK_SIZE + 2 - 1 : 0] full_pack;
    assign full_pack = {1'b1, data, 1'b0};
    for (int i = 0; i < PACK_SIZE + 2; i = i + 1) begin
        rx_bit <= full_pack[i];
        repeat(CLK_PER_BIT) @(posedge clk);
    end
endtask

initial begin
    rst <= 1; rx_bit <= '1; @(posedge clk);
    rst <= 0; @(posedge clk);
    recieve_packet(PACK_DATA);
    repeat(2)@(posedge clk);
    if (PACK_DATA == rx_byte_data) begin
        $display("Test Passed!");
    end else begin
        $display("Test Failed!");
    end
    $stop;
end


endmodule