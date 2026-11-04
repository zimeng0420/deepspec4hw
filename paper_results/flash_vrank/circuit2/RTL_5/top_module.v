module top_module (
    input a,
    input b,
    input c,
    input d,
    output q
);

    assign q = (~a & ~b & ~c & ~d) |
               (~a & ~b &  c &  d) |
               (~a &  b &  0 &  1) |
               (~a &  b &  1 &  0) |
               ( a & ~b &  0 &  1) |
               ( a & ~b &  1 &  0) |
               (~a & b & 0 & 1) |
               (~a & b & 1 & 0) |
               ( a &  b &  0 &  0) |
               ( a &  b &  1 &  1);


endmodule