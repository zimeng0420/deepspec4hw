module top_module(
    input clk,
    input reset,
    output reg [4:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // Reset state to 1
        end else begin
            // Feedback calculation for Galois LFSR with taps at positions 5 and 3
            q <= {q[3:0], q[4] ^ q[2]};
        end
    end

endmodule