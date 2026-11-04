module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            shift_ena <= 1;      // Assert shift_ena when reset is high
            count <= 0;          // Start counting
        end else if (count < 3) begin
            count <= count + 1; // Increment count for 4 cycles total
            shift_ena <= 1;      // Keep shift_ena asserted
        end else begin
            shift_ena <= 0;      // Deassert shift_ena after 4 cycles
        end
    end

endmodule