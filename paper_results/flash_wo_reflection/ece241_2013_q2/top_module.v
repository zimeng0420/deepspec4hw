module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

    // Minimized SOP: out_sop = (!a & !b & c & !d) | (!a & b & c & d) | (a & b & c & d)
    assign out_sop = (~a & ~b & c & ~d) | (~a & b & c & d) | (a & b & c & d);

    // Minimized POS: out_pos = (c & d) & (~a | c) & (~b | c) & (~a | ~b)
    assign out_pos = (c & d) & (~a | c) & (~b | c) & (~a | ~b);

endmodule