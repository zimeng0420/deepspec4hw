module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] counter;

    // Sequential logic: Update counter and shift_ena output
    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'd0;           // Initialize counter on reset
            shift_ena <= 1'b1;         // Assert shift_ena on reset
        end
        else if (counter < 3'd4) begin
            counter <= counter + 1'b1; // Increment counter
            shift_ena <= 1'b1;         // Keep shift_ena asserted
        end
        else begin
            shift_ena <= 1'b0;         // De-assert shift_ena after 4 cycles
        end
    end

endmodule