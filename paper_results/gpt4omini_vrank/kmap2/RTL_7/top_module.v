module top_module (
    input a, 
    input b,
    input c,
    input d,
    output out
);
    assign out = (a & ~b & ~d) | (a & ~b & c) | (a & b & d) | (b & c) | (b & ~a & ~c) | (~a & b & ~d);
endmodule