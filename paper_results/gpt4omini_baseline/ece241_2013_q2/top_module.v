module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Sum-of-Products (SOP) for outputs 2, 7, 15
    assign out_sop = (a ~^ 1'b0) & (b ~^ 1'b0) & (c ~^ 1'b0) & (d ~^ 1'b1) |  // 2: 0010
                     (a ~^ 1'b0) & (b ~^ 1'b1) & (c ~^ 1'b1) & (d ~^ 1'b1) |  // 7: 0111
                     (a ~^ 1'b1) & (b ~^ 1'b1) & (c ~^ 1'b1) & (d ~^ 1'b1);   // 15: 1111

    // Product-of-Sums (POS) for outputs 0, 1, 4, 5, 6, 9, 10, 13, 14
    assign out_pos = (a | b | c | d) & 
                     (a | b | c | ~d) & 
                     (a | ~b | ~c | d) & 
                     (~a | b | ~c | d) & 
                     (~a | ~b | c | d) & 
                     (~a | ~b | ~c | ~d);

endmodule