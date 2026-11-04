module top_module (
    input a,
    input b,
    input c,
    input d,
    output out
);

    assign out = (~a & ~b & ~c & ~d) | 
                   (~a & ~b & ~c & d) |
                   (~a & ~b & c & b) |
                   (~a & b & ~c & ~d) |
                   (a & ~b & ~c & ~d) |
                   (a & ~b & ~c & b) |
                   (~a & ~d & c & d) | 
                   (a & c & d) |
                   (~a & d & c) |
                   (~b & ~c & d);

endmodule