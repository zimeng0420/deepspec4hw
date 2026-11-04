module top_module (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // 100-input AND gate implementation using reduction AND
    assign out_and = &in;

    // 100-input OR gate implementation using reduction OR
    assign out_or = |in;

    // 100-input XOR gate implementation using reduction XOR
    assign out_xor = ^in;

endmodule