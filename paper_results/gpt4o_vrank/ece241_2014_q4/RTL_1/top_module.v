module top_module (
    input clk,
    input x,
    output z
);

    wire q1, q2, q3;
    wire xor_result, and_result, or_result;

    // XOR gate with second input from corresponding flip-flop output
    assign xor_result = x ^ q1;

    // AND gate with second input from complementary flip-flop output
    assign and_result = x & ~q2;

    // OR gate with second input from complementary flip-flop output
    assign or_result = x | ~q3;

    // D Flip-Flops
    always @(posedge clk) begin
        q1 <= xor_result;
        q2 <= and_result;
        q3 <= or_result;
    end

    // Three-input XNOR gate
    assign z = ~(q1 ^ q2 ^ q3);

endmodule