module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    // Declare a counter to track the number of clock cycles for which shift_ena is active
    reg [2:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            // On reset, initialize the counter and set shift_ena
            counter <= 3'd0;
            shift_ena <= 1'b1;
        end else if (counter < 3'd4) begin
            // Increment the counter and maintain shift_ena
            counter <= counter + 3'd1;
            shift_ena <= 1'b1;
        end else begin
            // After 4 clock cycles, deassert shift_ena
            shift_ena <= 1'b0;
        end
    end

endmodule