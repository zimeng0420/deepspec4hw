module top_module (
    input clk,
    input x,
    output reg z
);

    reg q1, q2, q3;

    always @(posedge clk) begin
        q1 <= x ^ q1;      // XOR gate
        q2 <= x & ~q2;     // AND gate
        q3 <= x | ~q3;     // OR gate
    end

    always @(*) begin
        z = ~(q1 ^ q2 ^ q3);  // XNOR gate
    end

endmodule