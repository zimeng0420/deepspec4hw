module top_module(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            // Shift operation
            q[3] <= data;
            q[2] <= q[3];
            q[1] <= q[2];
            q[0] <= q[1];
        end else if (count_ena) begin
            // Decrement operation
            q <= (q == 0) ? 4'b1111 : q - 1; // Handle underflow
        end
        // else: Do nothing (hold the current value)
    end

endmodule