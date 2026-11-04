module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    assign out_both[98] = in[98] & in[99];
    assign out_both[97] = in[97] & in[98];
    assign out_both[96] = in[96] & in[97];
    // ...
    assign out_both[0] = in[0] & in[1]; // Continue until out_both[98]

    assign out_any[99] = in[99] | in[98];
    assign out_any[98] = in[98] | in[97];
    assign out_any[97] = in[97] | in[96];
    // ...
    assign out_any[1] = in[1] | in[0]; // Continue until out_any[99]

    assign out_different[0] = in[0] ^ in[99];
    assign out_different[1] = in[1] ^ in[0];
    assign out_different[2] = in[2] ^ in[1];
    // ...
    assign out_different[99] = in[99] ^ in[98]; // Continue until out_different[99]

endmodule