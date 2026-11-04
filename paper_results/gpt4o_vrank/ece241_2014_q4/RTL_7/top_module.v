module top_module (
    input clk,
    input x,
    output z
);

    wire q1, q2, q3;
    wire d1, d2, d3;
    wire xnor_input1, xnor_input2, xnor_input3;

    // Gates
    assign d1 = x ^ q1;          // XOR gate
    assign d2 = x & ~q2;         // AND gate
    assign d3 = x | ~q3;         // OR gate

    // D flip-flops
    always @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end

    // XNOR gate
    assign xnor_input1 = q1;
    assign xnor_input2 = q2;
    assign xnor_input3 = q3;
    assign z = ~(xnor_input1 ^ xnor_input2 ^ xnor_input3); // XNOR through NOT(XOR)

endmodule