module top_module(
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Feedback calculation based on taps at positions 32, 22, 2, 1
            q[0] <= q[31] ^ q[21] ^ q[1] ^ q[0]; // Feedback for LFSR
            q[31:1] <= q[30:0]; // Shift operation
        end
    end

endmodule