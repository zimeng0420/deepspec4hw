module top_module (
    input clk,
    input x,
    output z
);

    reg d0, d1, d2;
    wire q0, q1, q2;
    wire qn1, qn2;

    // D flip-flops
    always @(posedge clk) begin
        d0 <= x ^ q0;        // XOR gate
        d1 <= x & ~q1;       // AND gate with complemented output
        d2 <= x | ~q2;       // OR gate with complemented output
    end

    // Assign the outputs to the flip-flops' outputs
    assign q0 = d0;
    assign q1 = d1;
    assign q2 = d2;

    // Complement outputs of q1 and q2
    assign qn1 = ~q1;
    assign qn2 = ~q2;

    // XNOR gate with three inputs
    assign z = ~(q0 ^ q1 ^ q2);

endmodule