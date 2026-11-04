module top_module (
    input clk,
    input x,
    output reg z
);

    reg q1, q2, q3;
    wire q1_bar, q2_bar, q3_bar;
    wire d1, d2, d3;

    // Complement outputs of the flip-flops
    assign q1_bar = ~q1;
    assign q2_bar = ~q2;
    assign q3_bar = ~q3;

    // Logic gates
    assign d1 = x ^ q1;           // XOR Gate
    assign d2 = x & q2_bar;       // AND Gate
    assign d3 = x | q3_bar;       // OR Gate

    // D Flip-Flops
    always @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end

    // XNOR Gate
    always @(*) begin
        z = ~(q1 ^ q2 ^ q3);
    end

endmodule