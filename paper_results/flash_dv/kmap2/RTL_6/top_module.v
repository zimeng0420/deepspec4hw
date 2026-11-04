module top_module(
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire not_a, not_b, not_c, not_d;

    assign not_a = ~a;
    assign not_b = ~b;
    assign not_c = ~c;
    assign not_d = ~d;

    assign out = (not_a & not_b & not_c & not_d) |
                 (not_a & not_b & c & not_d) |
                 (not_a & b & not_c & not_d) |
                 (not_a & b & c & d) |
                 (a & not_b & not_c & not_d) |
                 (a & not_b & c & not_d) |
                 (a & b & not_c & not_d) |
                 (a & b & c & d) |
                 (a & not_b & c & d);

endmodule