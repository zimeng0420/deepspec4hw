module A (
  input x,
  input y,
  output z
);
  assign z = (x ^ y) & x;
endmodule

module B (
  input x,
  input y,
  output z
);
  always_comb
    begin
      case ({x, y})
        2'b00: z = 1'b1;
        2'b01: z = 1'b0;
        2'b10: z = 1'b0;
        2'b11: z = 1'b1;
        default: z = 1'b0; //Handle any unexpected input combination.
      endcase
    end
endmodule


module top_module (
  input x,
  input y,
  output z
);

  wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

  A a1 (
    .x(x),
    .y(y),
    .z(a1_out)
  );

  A a2 (
    .x(x),
    .y(y),
    .z(a2_out)
  );

  B b1 (
    .x(x),
    .y(y),
    .z(b1_out)
  );

  B b2 (
    .x(x),
    .y(y),
    .z(b2_out)
  );

  assign or_out = a1_out | b1_out;
  assign and_out = a2_out & b2_out;
  assign z = or_out ^ and_out;

endmodule