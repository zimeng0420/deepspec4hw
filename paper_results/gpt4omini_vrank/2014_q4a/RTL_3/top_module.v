module top_module (
    input clk,
    input w,
    input [n-1:0] R,
    input E,
    input L,
    output reg Q
);
    reg [n-1:0] shift_reg;

    always @(posedge clk) begin
        if (L) begin
            shift_reg <= R; // Load the value R
        end else if (E) begin
            shift_reg <= {shift_reg[n-2:0], w}; // Shift operation
        end
    end

    // Output the value of the desired stage
    always @(posedge clk) begin
        Q <= shift_reg[n-1]; // Output the most significant bit
    end

endmodule