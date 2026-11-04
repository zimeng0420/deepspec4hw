module top_module(
    input clk,
    input reset,
    output reg [4:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 5'b00001; // Reset to '00001'
        end else begin
            // Feedback from q[4] (bit 5) and q[2] (bit 3)
            q <= {q[3:0], q[4] ^ q[2]}; // Shift and insert new bit
        end
    end

endmodule