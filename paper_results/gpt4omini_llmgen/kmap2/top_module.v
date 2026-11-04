module top_module (
    input a, 
    input b,
    input c,
    input d,
    output out
);
    wire not_a, not_b, not_c, not_d;
    wire term1, term2, term3, term4, term5, term6, term7;

    assign not_a = ~a;
    assign not_b = ~b;
    assign not_c = ~c;
    assign not_d = ~d;

    assign term1 = not_a & not_c & not_d; // m0
    assign term2 = not_a & not_c & d;     // m1
    assign term3 = not_a & b & not_d;     // m4
    assign term4 = not_a & b & c;         // m8
    assign term5 = a & not_b & not_c;     // m9
    assign term6 = a & b & not_c;         // m10
    assign term7 = a & b & c & not_d;     // m14

    assign out = term1 | term2 | term3 | term4 | term5 | term6 | term7;
endmodule