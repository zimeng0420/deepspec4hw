module top_module(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift operation: shift left and input new data from MSB position
            q <= {q[2:0], data};
        end else if (count_ena) begin
            // Decrement operation: decrement the register value by 1
            q <= q - 1;
        end
        // If both shift_ena and count_ena are 1, the behavior is undefined.
    end

endmodule