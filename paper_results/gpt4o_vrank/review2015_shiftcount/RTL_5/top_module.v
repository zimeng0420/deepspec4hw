module top_module(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift in data MSB first
            q <= {q[2:0], data};
        end else if (count_ena) begin
            // Decrement the 4-bit register
            q <= q - 1;
        end
        // If both shift_ena and count_ena are 0, retain the current value of q
    end
endmodule