module top_module (
    input clk,
    input x,
    output z
);

    reg q1, q2, q3;

    always @(posedge clk) begin
        q1 <= x ^ q1;           // XOR gate with flip-flop output
        q2 <= x & ~q2;          // AND gate with complemented flip-flop output
        q3 <= x | ~q3;          // OR gate with complemented flip-flop output
    end

    assign z = ~(q1 ^ q2 ^ q3); // XNOR of all flip-flop outputs

endmodule