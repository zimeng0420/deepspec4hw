module top_module (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    assign out_and = &in;  // Reduction AND operator to compute 4-input AND
    assign out_or = |in;   // Reduction OR operator to compute 4-input OR
    assign out_xor = ^in;  // Reduction XOR operator to compute 4-input XOR
endmodule