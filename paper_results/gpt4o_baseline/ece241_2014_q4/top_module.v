module top_module (
    input clk,
    input x,
    output z
);

    // Internal signals for the flip-flop outputs
    reg q1, q2, q3;
    
    // Logic for the three D flip-flops
    wire d1 = x ^ q1;          // XOR with flip-flop's output
    wire d2 = x & ~q2;         // AND with flip-flop's complemented output
    wire d3 = x | ~q3;         // OR with flip-flop's complemented output

    // Flip-flop instantiation
    always @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end

    // XNOR all the flip-flop outputs
    assign z = ~(q1 ^ q2 ^ q3);

endmodule