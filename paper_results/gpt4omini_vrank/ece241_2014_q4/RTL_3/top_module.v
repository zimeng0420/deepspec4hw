module top_module (
    input clk,
    input x,
    output z
);
    reg q0, q1, q2;

    always @(posedge clk) begin
        q0 <= x ^ q0;       // XOR gate
        q1 <= x & ~q1;      // AND gate
        q2 <= x | ~q2;      // OR gate
    end

    assign z = q0 ~^ q1 ~^ q2; // Three-input XNOR

endmodule