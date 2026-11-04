module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimum Sum-of-Products (SOP) form
    assign out_sop = (~a & ~b & c & ~d) |    // 2 (0010)
                     ( a & b & c & d)   |    // 15 (1111)
                     (~a & b & c & c);      // 7(