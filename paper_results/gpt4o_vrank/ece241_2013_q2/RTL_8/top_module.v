module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimum Sum-of-Products (SOP) form
    assign out_sop = (~a & ~b & c & ~d) |  // for 2 (0010)
                     ( a & b & c & d)   |  // for 15 (1111)
                     ( a & ~b & c & c & d); // for 7 (0111)

    // Minimum Product-of-Sums (POS) form
    assign out_pos = ( a | ~b | ~c | ~d) &  // for not 2 (00 second bit: 0)
                      ( a | b | ~c | ~d) &  // for not 4, 5, 6 - bar 8
                      ( a | b | c | d ) &   // for 15 (1111)
                      ( ~a | b | c | d) & ( b | c | ~d); // for not 10, 13

endmodule