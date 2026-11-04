module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

  // Sum-of-Products (SOP) Implementation

  assign out_sop = (~a & ~b & b & ~d) |  // 2 (0010)
                   (~a & b & b & b) |   // 7 (0111)
                   (b & b & b & b);    // 15 (1111)

  // Product-of-Sums (POS) Implementation

  assign out_pos = ~( (a & b & c & d) | //0
                    (a & b & c & ~d) | //1
                    (a & b & ~c & d) | //4
                    (a & b & ~c & ~d)| //5
                    (a & b & c & ~d) | //6
                    (a & ~b & ~c & ~d)| //9
                    (a & ~b & c & d) | //10
                    (a & ~b & b & ~d)| //13
                    (a & ~b & b & d)  //14

                    );
    assign out_pos = (~(a & b)) & (~(a & c)) & (~(b & c & d)) & (~(a & b & c & d));

    // Alternative POS implementation (more efficient)
    // This implementation considers only the '0' outputs specified and uses the available don't cares.
    wire term0 = (a | b | c | d);  // Covers 0
    wire term1 = (a | b | c | ~d); // Covers 1
    wire term4 = (a | b | ~c | d); // Covers 4
    wire term5 = (a | b | ~c | ~d); // Covers 5
    wire term6 = (a | b | c | ~d); // Covers 6 (duplicate - can be removed or combined)
    wire term9 = (a | ~b | ~c | ~d); // Covers 9
    wire term10 = (a | ~b | c | d); // Covers 10
    wire term13 = (a | ~b | c | ~d); // Covers 13
    wire term14 = (a | ~b | c | d); // Covers 14 (duplicate - can be removed or combined)

     // Simplified POS using K-map optimization and the available don't cares:
    assign out_pos = (~a | ~b) & (~a | ~c) & (~b | ~c | ~d) ;  // Minimum POS form

endmodule