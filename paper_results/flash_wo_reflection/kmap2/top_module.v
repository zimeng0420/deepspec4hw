module top_module (
    input a,
    input b,
    input c,
    input d,
    output out
);

    wire not_a;
    wire not_c;
    wire not_b;
    wire not_d;

    assign not_a = ~a;
    assign not_c = ~c;
    assign not_b = ~b;
    assign not_d = ~d;

    wire term1;
    wire term2;
    wire term3;
    wire term4;

    assign term1 = not_a & not_c;
    assign term2 = not_b & not_c & not_d;
    assign term3 = b & c & d;
    assign term4 = a & b & not_c;

    assign out = term1 | term2 | term3 | term4;

endmodule