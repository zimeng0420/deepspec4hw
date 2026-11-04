module top_module (
    input clk,
    input x,
    output z
);

    // Internal wires for D flip-flop outputs
    wire dff_out1, dff_out2, dff_out3;
    wire dff_out1_n, dff_out2_n, dff_out3_n;

    // D Flip-Flops
    reg dff1, dff2, dff3;

    // Inverted outputs for flip-flops
    assign dff_out1_n = ~dff1;
    assign dff_out2_n = ~dff2;
    assign dff_out3_n = ~dff3;

    // Gate operations
    wire xor_out, and_out, or_out;

    // XOR gate
    assign xor_out = x ^ dff1;

    // AND gate
    assign and_out = x & dff_out2_n;

    // OR gate
    assign or_out = x | dff_out3_n;

    // D Flip-Flops behavior
    always @(posedge clk) begin
        dff1 <= xor_out;
        dff2 <= and_out;
        dff3 <= or_out;
    end

    // Three-input XNOR gate for output Z
    assign z = ~(dff_out1 ^ dff_out2 ^ dff_out3);

endmodule