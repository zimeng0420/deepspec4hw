module top_module (
    input clk,
    input x,
    output z
);

    wire xor_out, and_out, or_out;
    wire q1, q2, q3;
    wire q1_bar, q2_bar, q3_bar;
    
    // XOR gate with D flip-flop
    assign xor_out = x ^ q1;
    d_ff dff1 (
        .clk(clk),
        .d(xor_out),
        .q(q1)
    );

    // AND gate with D flip-flop
    assign q2_bar = ~q2;
    assign and_out = x & q2_bar;
    d_ff dff2 (
        .clk(clk),
        .d(and_out),
        .q(q2)
    );

    // OR gate with D flip-flop
    assign q3_bar = ~q3;
    assign or_out = x | q3_bar;
    d_ff dff3 (
        .clk(clk),
        .d(or_out),
        .q(q3)
    );

    // XNOR of all flip-flop outputs
    assign z = ~(q1 ^ q2 ^ q3);

endmodule

module d_ff (
    input clk,
    input d,
    output reg q
);
    always @(posedge clk) begin
        q <= d;
    end
endmodule