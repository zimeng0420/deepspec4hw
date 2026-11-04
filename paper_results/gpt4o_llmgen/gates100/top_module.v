module top_module (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // out_and is the AND operation across all input bits
    assign out_and = &in;

    // out_or is the OR operation across all input bits
    assign out_or = |in;

    // out_xor is the XOR operation across all input bits
    assign out_xor = ^in;

endmodule