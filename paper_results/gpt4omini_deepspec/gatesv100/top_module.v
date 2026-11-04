module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    assign out_both[98:0] = in[99:1] & in[98:0]; // Both current and left neighbor are '1'
    assign out_any[99:1] = in[99:0] | in[98:0]; // Any of current or right neighbor is '1'
    assign out_different[99:0] = in[99:0] ^ {in[98:0], in[99]}; // Current different from left neighbor (wrap around)

endmodule