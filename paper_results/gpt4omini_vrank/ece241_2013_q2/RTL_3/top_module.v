module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// minterms for output logic 1 (2, 7, 15): 0010, 0111, 1111
assign out_sop = (a & b & c & d) | (b & c & ~a & ~d) | (a & ~b & c & ~d);

// maxterms for output logic 0 (0, 1, 4, 5, 6, 9, 10, 13, 14): 0000, 0001, 0100, 0101, 0110, 1001, 1010, 1101, 1110
assign out_pos = (~a & ~b & ~c & ~d) & (~a & ~b & ~c & d) & (~a & b & ~c & ~d) & 
                 (~a & b & ~c & d) & (~a & b & c & ~d) & (a & ~b & ~c & d) & 
                 (a & ~b & c & ~d) & (a & b & ~c & ~d) & (a & b & c & ~d);

endmodule