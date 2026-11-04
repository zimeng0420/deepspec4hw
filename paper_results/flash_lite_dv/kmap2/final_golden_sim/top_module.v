module top_module (
    input a,
    input b,
    input c,
    input d,
    output out
);

  wire not_a, not_b, not_c, not_d;
  wire and1_out, and2_out, and3_out, and4_out;

  // Inverters
  not (not_a, a);
  not (not_b, b);
  not (not_c, c);
  not (not_d, d);

  // AND gates
  and (and1_out, not_a, not_c);  // a'c'
  and (and2_out, not_b, d);    // b'd
  and (and3_out, not_a, b);    // a'b
  and (and4_out, b, c);      // bc

  // OR gate
  or (out, and1_out, and2_out, and3_out, and4_out);

endmodule