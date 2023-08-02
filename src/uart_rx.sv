// Hevaily inspired by nandland at https://nandland.com/uart-serial-port-module/

// Clock per bit is created using (100000000Hz)/(115200 baud) = 868
// Parameterizable UART data packet size
// PARITY_EN enables the parity bit (1 or 0)
// EVEN_PAR says if even or odd parity (0 odd, 1 even)

`include "interfaces/interfaces.sv"

module uart_rx #( parameter CLK_PER_BIT = 868, PACK_SIZE = 8, PARITY_EN = 0, EVEN_PAR = 0) (
    input                           clk,             // input
    input                           rst,             // input
    itf_rx                          rx_0,             // rx_interface
    output logic                    par_error,       // output
    output logic                    stop_error       // output
);

parameter CLK_INDEX = $clog2(CLK_PER_BIT); // Number of bits to keep track of clock cycles
parameter DATA_BITS = $clog2(PACK_SIZE);   // Number of bits to keep track of data index

enum {IDLE, START, DATA, PARITY, STOP} RX_STATE;

logic [CLK_INDEX - 1 : 0] clk_counter; // Keep track of clock cycles to match baud rate
logic [DATA_BITS - 1 : 0] data_index;  // Track rx bits into byte buffer
logic                     rx_bit_r0, rx_bit_r1;    // registered version of rx_bit for metastability
logic                     par_error_flag;

// Double register input to clear metastablility errors
always_ff @(posedge clk) begin
    if (rst) begin
        rx_bit_r0 <= '1;
        rx_bit_r1 <= '1;
    end else begin
        rx_bit_r0 <= rx_0.rx_bit;
        rx_bit_r1 <= rx_bit_r0;
    end
end

always_ff @(posedge clk) begin
    case(RX_STATE)

        // IDLE:  Wait for rx_bit to go low
        IDLE: begin
            // Set all signals to initial state
            clk_counter    <= '0;
            data_index     <= '0;
            rx_0.rx_byte_valid  <= '0;
            rx_0.rx_active      <= '0;
            stop_error     <= '0;
            par_error      <= '0;
            par_error_flag <= '0;

            // If rx bit goes low then move to start state
            if (!rx_bit_r1) begin
                RX_STATE <= START;
                rx_0.rx_active <= 1'b1;
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
            if (clk_counter >= CLK_PER_BIT - 1) begin
                rx_0.rx_byte_data[data_index] <= rx_bit_r1;
                data_index               <= data_index + 1;
                clk_counter              <= 0;
                // Once all bits are filled move to get stop bit
                if (data_index == PACK_SIZE - 1) begin
                    // If parity is enabled then check parity bit
                    if (PARITY_EN) begin
                        RX_STATE <= PARITY;
                    end else begin
                        RX_STATE <= STOP;
                    end
                end
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end

        // PARITY: Check parity bit for errors if enabled
        PARITY: begin
            if (clk_counter >= CLK_PER_BIT - 1) begin
                // Send a pulse error based on if the parity bit is incorrect
                // Also set parity bit error flag so packet is not valid in stop state
                if(EVEN_PAR) begin
                    par_error      <= (^rx_0.rx_byte_data != rx_bit_r1); 
                    par_error_flag <= (^rx_0.rx_byte_data != rx_bit_r1);                   
                end else begin
                    par_error      <= (~^rx_0.rx_byte_data != rx_bit_r1);
                    par_error_flag <= (~^rx_0.rx_byte_data != rx_bit_r1); 
                end
                RX_STATE    <= STOP;
                clk_counter <= '0;
            end else begin
                clk_counter <= clk_counter + 1;
            end
        end

        // STOP:  Check stop bit is valid then exit
        STOP: begin
            // Clear parity error so it is a pulse
            par_error <= '0;
            // Wait for final bit and then go back to IDLE
            if (clk_counter >= CLK_PER_BIT - 1) begin

                // Checks if stop bit is correct and if there was a parity error
                // If either have a problem then the uart packet was not valid
                if(rx_bit_r1 & !par_error_flag) begin
                    rx_0.rx_byte_valid <= 1'b1;
                end else begin
                    rx_0.rx_byte_valid <= 1'b0;
                end
                
                // Update state and status bits
                RX_STATE <= IDLE;
                rx_0.rx_active <= 1'b0;

                // Sends a pulse error if stop bit is low
                stop_error <= ~rx_bit_r1;
                
                // clear par_error_flag
                par_error_flag <= 1'b0;
                
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

parameter CLK_PER_BIT = 5;     // Using 5 to cut down sim time
parameter PACK_SIZE   = 8;     // Packet sizes
parameter PACK_DATA   = 8'hFE; // Set Packet data
parameter PARITY_EN   = 1;  // Sets if parity is enabled
parameter EVEN_PAR    = 0;  // Sets even or odd parity (0 odd, 1 even)
parameter TOTAL_SIZE  = PACK_SIZE + 2 + PARITY_EN; // Data size + start and stop bit + parity bit if enabled

// Define the signals
logic clk;
logic rst;
itf_rx   #(.PACK_SIZE(PACK_SIZE)) rx_0 (clk);
logic par_error;
logic stop_error;

// Instantiate module
uart_rx #(
    .CLK_PER_BIT(CLK_PER_BIT),
    .PACK_SIZE(PACK_SIZE),
    .PARITY_EN(PARITY_EN),
    .EVEN_PAR(EVEN_PAR)
) dut (
    .clk(clk),                       // Input
    .rst(rst),                       // Input
    .rx_0(rx_0.routing),           // rx_interface           
    .par_error(par_error),           // Output
    .stop_error(stop_error)          // Output
);

// Create clock signal
initial begin
    clk <= 0; #5;
    forever begin 
        clk <= ~clk; #5;
    end
end

always_comb begin
    if (par_error) begin
        $display("par_error at %t", $time);
    end

    if (stop_error) begin
        $display("stop_error at %t", $time);
    end
end


task recieve_packet(
        input [PACK_SIZE - 1:0] data,
        input bit               force_par_error = 1'b0,
        input bit               force_stop_error = 1'b0
        );

    // Create full UART packet
    logic [TOTAL_SIZE - 1 : 0] full_pack;

    // Setup parity bit
    bit par_bit;
    
    // Setup stop bit for forced errors
    bit stop_bit;

    // Setup stop bit based on if error is wanted
    assign stop_bit = force_stop_error ? 1'b0 : 1'b1;

    // Setup parity bit based on if error is wanted
    if (force_par_error) begin
        // Force a parity error
        assign par_bit = EVEN_PAR ? ~^data : ^data;
    end else begin
        // Normal parity
        assign par_bit  = EVEN_PAR ? ^data : ~^data;
    end


    // Show test name
    $display("----------------------------------------------");
    if (force_par_error) begin
        // Force a parity error
        $display("Forced Parity Error Test");
    end else if (force_stop_error) begin
        $display("Forced Stop Error Test");
    end else begin
        // Normal parity
        $display("Normal Operation Test");
    end


    // Assign full UART packet based on if using parity or not
    assign full_pack = PARITY_EN ? {stop_bit, par_bit, data, 1'b0} : {stop_bit, data, 1'b0};
    
    // Send UART packet
    for (int i = 0; i < TOTAL_SIZE; i = i + 1) begin
        rx_0.rx_bit <= full_pack[i];
        repeat(CLK_PER_BIT) @(posedge clk);
    end

    // Wait a few cycles
    wait(dut.RX_STATE == dut.IDLE);

    // Show which error or check if data is correct
    if (force_par_error) begin
        $display("Forced Parity Error!\n\n");
    end else if (force_stop_error) begin
        $display("Forced Stop Error!\n\n");
    end else if (PACK_DATA == rx_0.rx_byte_data & rx_0.rx_byte_valid) begin
        $display("Test Passed, expected: 0x%h, received: 0x%h!\n\n", PACK_DATA, rx_0.rx_byte_data);
    end else begin
        $display("Test Failed, expected: 0x%h, received: 0x%h!\n\n", PACK_DATA, rx_0.rx_byte_data);
    end
    $display("----------------------------------------------\n");

endtask

initial begin
    rst <= 1; rx_0.rx_bit <= '1; @(posedge clk);
    rst <= 0; repeat(3) @(posedge clk);
    recieve_packet(PACK_DATA, 1'b1);
    recieve_packet(PACK_DATA, 1'b0, 1'b1);
    recieve_packet(PACK_DATA);
    $stop;
end


endmodule