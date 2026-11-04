module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-Products Form
    assign out_sop = (~a & ~b & c & ~d) |  // Minterm for 2
                     (~a & b & c & d)  |  // Minterm for 7
                     (a & b & c & d);    // Minterm for 15

    // Product-of-Sums Form
    assign out_pos = (a | b | c | d) &     // Maxterm for 0
                     (a | b | c | ~d) &    // Maxterm for 1
                     (a | ~b | c | d) &    // Maxterm for 4
                     (a | ~b | c | ~d) &   // Maxterm for 5
                     (a | ~b | ~c | d) &   // Maxterm for 6
                     (~a | b | c | ~d) &   // Maxterm for 9
                     (~a | b | ~c | d) &   // Maxterm for 10
                     (~a | ~b | c | ~d) &  // Maxterm for 13
                     (~a | ~b | ~c | d);   // Maxterm for 14

endmodule