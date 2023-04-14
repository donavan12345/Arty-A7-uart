module uart_top_tb();

logic clk;
logic [3:0] sw;
logic uart_txd_in;

logic uart_rxd_out;
logic [7:0] LED;



// Instantiate uart_top module
uart_top dut (
    .CLK100MHZ(clk),
    .sw(sw),
    .uart_txd_in(uart_txd_in),
    .uart_rxd_out(uart_rxd_out),
    .LED(LED)
);
    
    
initial begin
    clk <= 0; #5;
    forever begin 
        clk <= ~clk; #5;
    end
end
    
    
initial begin
    sw[3:1] <= '0; sw[0] <= '1; @(posedge clk);
    sw[0] <= '0; @(posedge clk);
    for (int i = 0; i < 20; i++) begin
        @(posedge clk);
    end
    $stop;
end
    

endmodule