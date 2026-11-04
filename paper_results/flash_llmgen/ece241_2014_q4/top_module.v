module top_module (
    input clk,
    input x,
    output z
);

    // Internal signals
    reg q1, q2, q3;
    wire d1, d2, d3;
    wire not_q1, not_q2, not_q3;

    // Complement the flip-flop outputs
    assign not_q1 = ~q1;
    assign not_q2 = ~q2;
    assign not_q3 = ~q3;

    // Input logic for D flip-flops
    assign d1 = x ^ q1;
    assign d2 = x & not_q2;
    assign d3 = x | not_q3;

    // D flip-flops
    always @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end

    // Output logic (3-input XNOR)
    assign z = ~(q1 ^ q2 ^ q3);

endmodule