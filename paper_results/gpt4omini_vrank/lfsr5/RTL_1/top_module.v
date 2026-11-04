module top_module(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 5'b00001; // reset to 1
    end else begin
        // Galois LFSR feedback calculation
        q[4] <= q[3] ^ q[4]; // feedback from bits 5 and 3
        q <= {q[3:0], q[4]};  // shift operation
    end
end

endmodule