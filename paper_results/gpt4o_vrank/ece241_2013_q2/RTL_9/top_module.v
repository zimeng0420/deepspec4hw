module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // SOP: Minimum Sum-of-Products for function F(a,b,c,d) = Σ(2, 7, 15)
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // POS: Minimum Product-of-Sums for function F(a,b,c,d) = Π(0, 1, 4, 5, 6, 9, 10, 13, 14)
    assign out_pos = (a | b | ~c | d) & (a | ~b | c | ~d) & (a | ~b | c | d);

endmodule