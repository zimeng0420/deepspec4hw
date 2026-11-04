module top_module(
    input clk,
    input reset,
    output reg [4:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;  // Initialize LFSR state to 1 on reset
        end else begin
            q[4] <= q[0] ^ q[2]; // Feedback xor operation for taps
            q[3] <= q[4];
            q[2] <= q[3];
            q[1] <= q[2];
            q[0] <= q[1];
        end
    end
endmodule