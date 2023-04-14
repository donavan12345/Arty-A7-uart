// Hevaily inspired by nandland at https://nandland.com/uart-serial-port-module/

// Clock per bit is created using (100000000Hz)/(115200 baud) = 868
// Parameterizable UART data packet size
// PARITY_EN enables the parity bit (1 or 0)
// EVEN_PAR says if even or odd parity (0 odd, 1 even)
module uart_tx #( parameter CLK_PER_BIT = 868, PACK_SIZE = 8, PARITY_EN = 0, EVEN_PAR = 0) (
    input                    clk,             // input
    input                    rst,             // input
    input                    tx_byte_valid,   // input
    input [PACK_SIZE - 1 :0] tx_byte_data,    // input [PACK_SIZE - 1 :0]
    output logic             tx_bit,          // output
    output logic             tx_active,       // output
    output logic             tx_done          // output
);

parameter CLK_INDEX = $clog2(CLK_PER_BIT); // Number of bits to keep track of clock cycles
parameter DATA_BITS = $clog2(PACK_SIZE);   // Number of bits to keep track of data index


logic [PACK_SIZE - 1 :0]   tx_data_cap; // Captures data to send 
logic [CLK_INDEX - 1 : 0]  clk_counter; // Keep track of clock cycles
logic [DATA_BITS - 1 : 0]  data_index;  // Keep track of data bit being used

// Create states for state machine
enum {IDLE, START, DATA, PARITY, STOP} TX_STATE;


// Entire state machine is registered which means I don't
// Need a state_n. Not how I usually do state machines
// But makes more sense given I want to register all parts
always_ff @(posedge clk) begin
    case(TX_STATE)

        // IDLE: Wait for data to be valid and capture data to send
        IDLE: begin
            // Reset all values and stop active
            clk_counter <= '0;
            data_index  <= '0;
            tx_active   <= '0;
            tx_done     <= '0;
            tx_bit      <= '1;
            // Capture data and set out bit to 0 for START stage
            if (tx_byte_valid) begin
                tx_data_cap <= tx_byte_data;
                tx_active   <= 1'b1;
                TX_STATE    <= START;
            end
        end

        // START: Send start bit
        START: begin
            // Set start bit
            tx_bit <= 1'b0;
            // When enough clock cycles have passed to hit baud rate
            // clear clock and move to data send
            if (clk_counter >= CLK_PER_BIT - 1) begin
                clk_counter <= '0;
                TX_STATE    <= DATA;
            // If enough clock cycles has not passed, continue to increment
            // clk_counter and wait
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end

        // DATA: Create data state where byte is sent
        DATA: begin
            tx_bit <= tx_data_cap[data_index];
            // Check if enough clk cycles have passed to hit baud rate
            if (clk_counter >= CLK_PER_BIT - 1) begin
                // If all data has been processed then move to send stop bit
                if (data_index == PACK_SIZE - 1) begin
                    // Go to parity stage if parity is enabled
                    if(PARITY_EN) begin
                        TX_STATE    <= PARITY;
                    end else begin
                        TX_STATE    <= STOP;
                    end
                    data_index  <= '0;
                // If there is more data to send then increment data index
                // and stay in data state
                end else begin
                    data_index <= data_index + 1;
                end
                // Clear clk_counter to start next bit
                clk_counter <= '0;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end

        // PARITY: Add in parity bit based on what parameters are set for module
        PARITY: begin
            // Give even or odd parity based on parameter set
            if (EVEN_PAR) begin
                tx_bit <= ^tx_data_cap; // This is the xor of all data bits
            end else begin
                tx_bit <= ~^tx_data_cap;
            end

            // Move on to stop bit once the baud rate is hit
            if (clk_counter >= CLK_PER_BIT - 1) begin
                TX_STATE <= STOP;
                clk_counter <= '0;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end

        // STOP: Send stop bit and return to IDLE
        STOP: begin
            // Set stop bit
            tx_bit <= 1'b1;

            // Wait until stop bit has been transferred and then 
            // transistion back to IDLE state and signal done
            if (clk_counter >= CLK_PER_BIT - 1) begin
                TX_STATE   <= IDLE;
                tx_active  <= 1'b0;
                tx_done    <= 1'b1;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end

        default: 
            TX_STATE <= IDLE;
    endcase
end

endmodule

module uart_tx_tb();

parameter CLK_PER_BIT = 3;  // Using 3 to cut down sim time
parameter PACK_SIZE   = 8;  // Packet sizes
parameter PARITY_EN   = 1;  // Sets if parity is enabled
parameter EVEN_PAR    = 1;  // Sets even or odd parity (0 odd, 1 even)
// Define the signals
logic clk;
logic rst;
logic tx_byte_valid;
logic [PACK_SIZE - 1:0] tx_byte_data;
logic tx_bit;
logic tx_active;
logic tx_done;

// Instantiate module
uart_tx #(
    .CLK_PER_BIT(CLK_PER_BIT),
    .PACK_SIZE(PACK_SIZE),
    .PARITY_EN(PARITY_EN),
    .EVEN_PAR(EVEN_PAR)
) dut (
    .clk(clk),
    .rst(rst),
    .tx_byte_valid(tx_byte_valid),
    .tx_byte_data(tx_byte_data),
    .tx_bit(tx_bit),
    .tx_active(tx_active),
    .tx_done(tx_done)
);

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
    rst <= 1; tx_byte_valid <= '0; tx_byte_data <= '0; @(posedge clk);
    rst <= 0; @(posedge clk);
    send_packet(8'hAA);
    repeat(2)@(posedge clk);

    $stop;
end


endmodule