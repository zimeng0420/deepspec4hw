module top_module (
    input clk,
    input x,
    output z
);
    reg dff1, dff2, dff3;

    wire and_input, or_input, xor_input;
    wire dff1_complement, dff2_complement, dff3_complement;

    assign dff1_complement = ~dff1;
    assign dff2_complement = ~dff2;
    assign dff3_complement = ~dff3;

    assign xor_input = x ^ dff1; // XOR gate
    assign and_input = x & dff2_complement; // AND gate
    assign or_input = x | dff3_complement; // OR gate

    always @(posedge clk) begin
        dff1 <= xor_input; // Input to D flip-flop 1
        dff2 <= and_input; // Input to D flip-flop 2
        dff3 <= or_input; // Input to D flip-flop 3
    end

    assign z = dff1 ^ dff2 ^ dff3; // Three-input XNOR

endmodule