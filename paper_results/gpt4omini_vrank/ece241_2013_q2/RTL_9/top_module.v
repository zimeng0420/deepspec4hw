module top_module (
    input a,
    input b,
    input c,
    input d,
    output out_sop,
    output out_pos
);

// Sum of Products (SOP) for output 1 when inputs are 2, 7, or 15
assign out_sop = (a ~^ b ~^ c ~^ d == 2) | (a ~^ b ~^ c ~^ d == 7) | (a ~^ b ~^ c ~^ d == 15);

// Product of Sums (POS) for output 0 when inputs are 0, 1, 4, 5, 6, 9, 10, 13, or 14
assign out_pos = (a | b | c | d) & (~a | ~b | ~c | ~d);

// Simplified POS form
assign out_pos = (d | (b & c)) & (~a | ~b) & (~c | ~d);

endmodule