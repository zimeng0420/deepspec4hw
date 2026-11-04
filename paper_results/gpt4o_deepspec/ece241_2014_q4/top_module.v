module top_module (
    input clk,
    input x,
    output z
);

    // Declare registers for D flip-flops outputs
    reg Q1, Q2, Q3;

    // Intermediate signals for combinational logic
    wire XOR_out, AND_out, OR_out;

    // Combinational logic
    assign XOR_out = x ^ Q1;           // XOR Gate
    assign AND_out = x & ~Q2;          // AND Gate with complemented Q2
    assign OR_out = x | ~Q3;           // OR Gate with complemented Q3

    // Sequential logic: D flip-flops
    always @(posedge clk) begin
        Q1 <= XOR_out;
        Q2 <= AND_out;
        Q3 <= OR_out;
    end

    // Final XNOR Gate
    assign z = ~(XOR_out ^ AND_out ^ OR_out);

endmodule