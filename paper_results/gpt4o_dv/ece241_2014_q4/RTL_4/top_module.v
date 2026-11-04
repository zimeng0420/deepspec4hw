module top_module (
    input clk,
    input x,
    output reg z
);

    // Intermediate flip-flop outputs
    reg Q1, Q2, Q3;

    // Combinational logic using always block
    always @(posedge clk) begin
        // XOR Gate: `XOR_out = x ⊕ Q1`
        Q1 <= x ^ Q1;
        
        // AND Gate: `AND_out = x ∧ Q2'`, (Note: Q2' is the complemented output)
        Q2 <= x & ~Q2;
        
        // OR Gate: `OR_out = x ∨ Q3'`, (Note: Q3' is the complemented output)
        Q3 <= x | ~Q3;
    end

    // XNOR Gate combining outputs of the XOR, AND, OR gates
    always @(*) begin
        z = ~(Q1 ^ Q2 ^ Q3);
    end

endmodule