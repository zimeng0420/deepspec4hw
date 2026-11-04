module top_module(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (shift_ena) begin
            q <= {data, q[3:1]}; // Shift data in MSB first
        end else if (count_ena) begin
            q <= q - 1; // Decrement the value in the register
        end
        // If both are high, the behavior is unspecified and is not handled.
    end

endmodule