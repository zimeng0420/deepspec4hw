module top_module (
    input a, 
    input b,
    input c,
    input d,
    output out
);

    assign out = (a & ~b & ~c) | 
                 (~a & b & c) | 
                 (b & ~c & ~d) | 
                 (~b & c & d) | 
                 (a & ~c & d);

endmodule