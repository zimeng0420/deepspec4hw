module top_module(
    input clk,
    input x,
    output z
);

    // Internal signals
    wire xor_out;
    wire and_out;
    wire or_out;
    wire q1, q2, q3, q2_n, q3_n;

    // XOR gate
    xor #( .WIDTH(1) ) xor_gate (
        .a(x),
        .b(q1),
        .y(xor_out)
    );

    // AND gate
    not #( .WIDTH(1) ) not_q2 (
        .in(q2),
        .out(q2_n)
    );

    and #( .WIDTH(1) ) and_gate (
        .a(x),
        .b(q2_n),
        .y(and_out)
    );

    // OR gate
    not #( .WIDTH(1) ) not_q3 (
        .in(q3),
        .out(q3_n)
    );

    or #( .WIDTH(1) ) or_gate (
        .a(x),
        .b(q3_n),
        .y(or_out)
    );

    // D flip-flops
    always @(posedge clk) begin
        q1 <= xor_out;
    end

    always @(posedge clk) begin
        q2 <= and_out;
    end

    always @(posedge clk) begin
        q3 <= or_out;
    end


    // XNOR gate
    xnor #( .WIDTH(1) ) xnor_gate (
        .a(q1),
        .b(q2),
        .y(z)
    );

    // Another XNOR gate for completing the XNOR operation with q3
    // xnor #( .WIDTH(1) ) xnor_out_q3 (
    //     .a(xnor_gate_out), //output of first XNOR
    //     .b(q3),
    //     .y(z)
    // );


endmodule

// Helper modules for the gates
module xor (
    input  logic  a,
    input  logic  b,
    output logic  y
);
  assign y = a ^ b;
endmodule


module and (
    input  logic  a,
    input  logic  b,
    output logic  y
);
  assign y = a & b;
endmodule

module or (
    input  logic  a,
    input  logic  b,
    output logic  y
);
  assign y = a | b;
endmodule


module xnor (
    input  logic  a,
    input  logic  b,
    output logic  y
);
  assign y = ~(a ^ b);
endmodule

module not (
  input logic in,
  output logic out
);
  assign out = ~in;
endmodule