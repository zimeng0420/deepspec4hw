module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

wire [15:0] inputs = {a, b, c, d};

// Sum-of-Products for minterms 2, 7, 15
assign out_sop = (inputs[2] | inputs[7] | inputs[15]);

// Product-of-Sums for maxterms 0, 1, 4, 5, 6, 9, 10, 13, 14
assign out_pos = (inputs[0] & inputs[1] & inputs[2] & inputs[3]) |
                 (inputs[0] & inputs[1] & ~inputs[2] & inputs[3]) |
                 (inputs[0] & ~inputs[1] & inputs[2] & inputs[3]) |
                 (~inputs[0] & inputs[1] & inputs[2] & inputs[3]) |
                 (inputs[0] & inputs[1] & inputs[2] & ~inputs[3]) |
                 (inputs[0] & ~inputs[1] & ~inputs[2] & inputs[3]) |
                 (~inputs[0] & inputs[1] & ~inputs[2] & inputs[3]) |
                 (~inputs[0] & ~inputs[1] & inputs[2] & inputs[3]) |
                 (~inputs[0] & ~inputs[1] & ~inputs[2] & inputs[3]);

endmodule