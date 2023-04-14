module blink_1sec #(
    parameter CLKMHZ = 100
) (
    input clk,
    input rst,
    output reg strobe
);

logic [2:0] [9:0] LED_Blink_Counts;

always_ff @(posedge clk) begin
    if (rst) begin
        LED_Blink_Counts <= '0;
        strobe <= '0;
    end else begin
        if (LED_Blink_Counts[2] == CLKMHZ) begin
            LED_Blink_Counts <= '0;
            strobe <= 1'b1;
        end else if (LED_Blink_Counts[1] == 1000) begin
            LED_Blink_Counts[2] <= LED_Blink_Counts[2] + 10'h1;
            LED_Blink_Counts[1] <= '0;
            strobe <= 1'b0;
        end else if (LED_Blink_Counts[0] == 1000) begin
            LED_Blink_Counts[1] <= LED_Blink_Counts[1] + 10'h1;
            LED_Blink_Counts[0] <= '0;
            strobe <= 1'b0;
        end else begin
            LED_Blink_Counts[0] <= LED_Blink_Counts[0] + 10'h1;
            strobe <= 1'b0;
        end
    end
end

endmodule