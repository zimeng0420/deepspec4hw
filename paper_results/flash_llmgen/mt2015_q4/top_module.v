module top_module(
    input x,
    input y,
    output z);

    // Internal signals for intermediate values
    wire a1_out, a2_out, b1_out, b2_out, or_out, and_out;

    // Instantiate two instances of module A
    module_A a1 (
        .x(x),
        .y(y),
        .z(a1_out)
    );

    module_A a2 (
        .x(x),
        .y(y),
        .z(a2_out)
    );

    // Instantiate two instances of module B
    module_B b1 (
        .x(x),
        .y(y),
        .z(b1_out)
    );

    module_B b2 (
        .x(x),
        .y(y),
        .z(b2_out)
    );

    // OR gate
    assign or_out = a1_out | b1_out;

    // AND gate
    assign and_out = a2_out & b2_out;

    // XOR gate
    assign z = or_out ^ and_out;

endmodule

// Implementation of Module A
module module_A(
    input x,
    input y,
    output z
);

    assign z = (x ^ y) & x;

endmodule

// Implementation of Module B (Behavioral Model based on waveform)
module module_B(
    input x,
    input y,
    output reg z
);

  always @(x, y) begin
    case ({x, y})
      2'b00: z = 1;
      2'b01: z = 0;
      2'b10: z = 0;
      2'b11: z = 1;
      default: z = 1'bx; // Unknown state for unexpected inputs
    endcase
  end

endmodule