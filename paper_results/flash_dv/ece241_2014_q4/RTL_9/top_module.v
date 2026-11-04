module top_module (
    input clk,
    input x,
    output z
);

  reg q1, q2, q3;
  wire d1, d2, d3;
  wire q2_bar, q3_bar;

  // Next state logic
  assign d1 = x ^ q1;
  assign d2 = x & q2_bar;
  assign d3 = x | q3_bar;

  // Complement generation
  assign q2_bar = ~q2;
  assign q3_bar = ~q3;

  // Output logic
  assign z = ~(q1 ^ q2 ^ q3);

  // D flip-flops
  always @(posedge clk) begin
    q1 <= d1;
    q2 <= d2;
    q3 <= d3;
  end

  // Initial reset (optional, but good practice)
  initial begin
    q1 <= 0;
    q2 <= 0;
    q3 <= 0;
  end

endmodule