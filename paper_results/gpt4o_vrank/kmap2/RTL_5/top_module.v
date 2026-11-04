module top_module (
    input a, 
    input b,
    input c,
    input d,
    output out
);

    assign out = (~a & ~c) | (~b & ~c & d) | (~b & c & d) | (a & b & c) | (a & ~b & ~d) | (~a & b & d);

endmodule