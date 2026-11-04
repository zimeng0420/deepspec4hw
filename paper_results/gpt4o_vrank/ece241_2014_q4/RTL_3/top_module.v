module top_module (
    input clk,
    input x,
    output z
);

    reg q1, q2, q3;
    wire x_xor_q1, x_and_nq2, x_or_nq3;
    
    // XOR gate with flip-flop's output
    assign x_xor_q1 = x ^ q1;
    
    // AND gate with complementary output of flip-flop
    assign x_and_nq2 = x & ~q2;
    
    // OR gate with complementary output of flip-flop
    assign x_or_nq3 = x | ~q3;

    always @(posedge clk) begin
        q1 <= x_xor_q1;
        q2 <= x_and_nq2;
        q3 <= x_or_nq3;
    end

    // Three-input XNOR gate
    assign z = ~(q1 ^ q2 ^ q3);

endmodule