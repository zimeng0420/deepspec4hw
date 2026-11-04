module top_module(
    input clk,
    input reset,
    output reg [31:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            // Feedback calculation from taps
            wire feedback = q[31] ^ q[21] ^ q[1] ^ q[0]; 
            // Shift logic
            q <= {feedback, q[31:1]};
        end
    end

endmodule