module top_module(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // Initialize the LFSR to 1 on reset
        end else begin
            // Calculate the feedback bit using XOR of q[4] and q[2]
            // Update the LFSR using Galois LFSR shift logic
            q <= {q[3] ^ q[0], q[4], q[3], q[2], q[1]};     
        end
    end

endmodule