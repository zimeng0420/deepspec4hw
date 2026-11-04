module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-Products (SOP) form
    assign out_sop = (~a & ~b & b & ~d) |  // 2 (0010)
                     (~a & b & b & b) |  // 7 (0111)
                     (b & b & b & b);   // 15 (1111)

    // Product-of-Sums (POS) form
    assign out_pos = (~a | ~b | ~c | ~d) &  // 0
                     (~a | ~b | ~c | d) &   // 1
                     (~a | ~b | c | ~d) &   // 4
                     (~a | ~b | c | d) &    // 5
                     (~a | b | ~c | ~d) &   // 6
                     (a | ~b | ~c | ~d) &    // 9
                     (a | ~b | ~c | d) &     // 10
                     (a | b | ~c | d) &      // 13
                     (a | b | c | ~d);       // 14

endmodule