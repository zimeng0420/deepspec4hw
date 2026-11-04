module top_module(
    input clk,
    input reset,
    output reg [31:0] q
);

    reg [31:0] next_q;
    wire feedback;

    // Calculate the feedback value (XOR of tap bits)
    assign feedback = q[31] ^ q[21] ^ q[1] ^ q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1; // Reset to 1
        end else begin
            // Calculate the next state
            next_q[0] <= feedback;
            next_q[31:1] <= q[30:0]; // Shift right
            q <= next_q;
        end
    end

endmodule