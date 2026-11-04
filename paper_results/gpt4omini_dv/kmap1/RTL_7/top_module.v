module top_module(
    input a, 
    input b,
    input c,
    output out
);

assign out = (b & ~a) | (b & c) | (a & c) | (a & ~b) | (a & ~c); // derived from K-map

endmodule