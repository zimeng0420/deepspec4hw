module top_module(
    input clk,
    input x,
    output reg z
);

    reg Q1, Q2, Q3;

    always @(posedge clk) begin
        Q1 <= x ^ Q1;          // XOR gate with second input as Q1
        Q2 <= x & ~Q2;         // AND gate with second input as ~Q2 (Q2')
        Q3 <= x | ~Q3;         // OR gate with second input as ~Q3 (Q3')
    end

    always @(*) begin
        z = ~(Q1 ^ Q2 ^ Q3);  // XNOR gate with three inputs: Q1, Q2, Q3
    end

endmodule