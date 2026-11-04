module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [2:0] counter;  // 3-bit counter to count clock cycles

    always @(posedge clk) begin
        if (reset) begin
            counter <= 3'b000;  // Initialize counter on reset
            shift_ena <= 1'b1;  // Enable shift for 4 cycles upon reset
        end else if (counter < 3'b100) begin
            counter <= counter + 1'b1;  // Increment counter
            shift_ena <= 1'b1;  // Keep shift_ena asserted for 4 cycles
        end else begin
            shift_ena <= 1'b0;  // De-assert shift_ena after 4 cycles
        end
    end

endmodule