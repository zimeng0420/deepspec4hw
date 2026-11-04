module top_module(
    input clk,
    input x,
    output z
);

    // Internal signals
    wire xor_out;
    wire and_out;
    wire or_out;
    wire q1, q2, q3;
    wire q2_not, q3_not;

    // XOR gate
    xor #(1) xor_gate (
        .in1(x),
        .in2(q1),
        .out(xor_out)
    );

    // NOT gate for q2
    not not_q2 (
        .in(q2),
        .out(q2_not)
    );

    // AND gate
    and #(1) and_gate (
        .in1(x),
        .in2(q2_not),
        .out(and_out)
    );

    // NOT gate for q3
    not not_q3 (
        .in(q3),
        .out(q3_not)
    );
    
    // OR gate
    or #(1) or_gate (
        .in1(x),
        .in2(q3_not),
        .out(or_out)
    );

    // D flip-flop 1
    always @(posedge clk) begin
        q1 <= xor_out;
    end

    // D flip-flop 2
    always @(posedge clk) begin
        q2 <= and_out;
    end

    // D flip-flop 3
    always @(posedge clk) begin
        q3 <= or_out;
    end

    // XNOR gate
    xnor3 xnor_gate (
        .in1(q1),
        .in2(q2),
        .in3(q3),
        .out(z)
    );

endmodule

module xor (
  input in1,
  input in2,
  output out
);

  assign out = in1 ^ in2;

endmodule

module and (
  input in1,
  input in2,
  output out
);

  assign out = in1 & in2;

endmodule

module or (
  input in1,
  input in2,
  output out
);

  assign out = in1 | in2;

endmodule

module not (
  input in,
  output out
);

  assign out = ~in;

endmodule

module xnor3 (
  input in1,
  input in2,
  input in3,
  output out
);

  wire xnor12;

  xnor xnor1(
    .in1(in1),
    .in2(in2),
    .out(xnor12)
  );

  xnor xnor2(
    .in1(xnor12),
    .in2(in3),
    .out(out)
  );

endmodule
