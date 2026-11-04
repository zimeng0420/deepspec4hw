module top_module(
    input clk,
    input reset,
    output reg [4:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // Reset to state 1
        end else begin
            // Shift and XOR based on taps at positions 5 and 3
            q <= {q[3:0], q[4] ^ q[2]};
        end
    end

endmodule