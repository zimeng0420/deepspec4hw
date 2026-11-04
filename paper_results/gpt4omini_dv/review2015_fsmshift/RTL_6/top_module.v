module top_module(
    input clk,
    input reset,
    output reg shift_ena
);

    reg [3:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count <= 4'b1111;  // Load count to 4
            shift_ena <= 1'b1;  // Assert shift_ena high
        end else if (count > 0) begin
            count <= count - 1; // Decrement count
            shift_ena <= 1'b1;  // Keep asserting shift_ena
        end else begin
            shift_ena <= 1'b0;  // Deassert shift_ena after 4 cycles
        end
    end

endmodule