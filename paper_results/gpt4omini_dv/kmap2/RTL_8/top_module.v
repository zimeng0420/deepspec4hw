module top_module (
    input a, 
    input b,
    input c,
    input d,
    output out
);

wire not_a, not_b, not_c, not_d;
wire term1, term2, term3, term4, term5, term6, term7, term8, term9;

not g1(not_a, a);
not g2(not_b, b);
not g3(not_c, c);
not g4(not_d, d);

and g5(term1, not_a, not_b, not_c, not_d); // a'b'c'd'
and g6(term2, not_a, not_b, not_c, d);    // a'b'cd'
and g7(term3, not_a, not_b, c, not_d);    // a'b c'd'
and g8(term4, not_a, not_b, c, d);        // a'b cd
and g9(term5, a, not_b, not_c, not_d);    // ab'c'd'
and g10(term6, a, not_b, not_c, d);       // ab'cd'
and g11(term7, a, b, c, not_d);            // abc'd'
and g12(term8, a, b, c, d);                // abcd
and g13(term9, a, not_b, c, d);            // ab'cd

or g14(out, term1, term2, term3, term4, term5, term6, term7, term8, term9);

endmodule