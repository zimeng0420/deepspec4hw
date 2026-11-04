module top_module(
    input clk,
    input x,
    output z
);

    // Internal signals
    wire xor_out;
    wire and_out;
    wire or_out;
    wire q1;
    wire q2;
    wire q3;
    wire q2_bar;
    wire q3_bar;

    // XOR gate
    xor #(1) xor_gate (
        .a(x),
        .b(q1),
        .y(xor_out)
    );

    // AND gate
    not #(1) not_q2 (
        .a(q2),
        .y(q2_bar)
    );
    and #(1) and_gate (
        .a(x),
        .b(q2_bar),
        .y(and_out)
    );

    // OR gate
    not #(1) not_q3 (
        .a(q3),
        .y(q3_bar)
    );
    or #(1) or_gate (
        .a(x),
        .b(q3_bar),
        .y(or_out)
    );

    // D flip-flops
    dff dff1 (
        .clk(clk),
        .d(xor_out),
        .q(q1)
    );

    dff dff2 (
        .clk(clk),
        .d(and_out),
        .q(q2)
    );

    dff dff3 (
        .clk(clk),
        .d(or_out),
        .q(q3)
    );

    // XNOR gate
    xnor3 #(1) xnor_gate (
        .a(q1),
        .b(q2),
        .c(q3),
        .y(z)
    );

endmodule

// XOR gate module
module xor (
  input a,
  input b,
  output y
);
  assign y = a ^ b;
endmodule
module xor #(parameter WIDTH = 1) (
  input  [WIDTH-1:0] a,
  input  [WIDTH-1:0] b,
  output [WIDTH-1:0] y
);
  assign y = a ^ b;
endmodule


// AND gate module
module and (
  input a,
  input b,
  output y
);
  assign y = a & b;
endmodule
module and #(parameter WIDTH = 1) (
  input  [WIDTH-1:0] a,
  input  [WIDTH-1:0] b,
  output [WIDTH-1:0] y
);
  assign y = a & b;
endmodule

// OR gate module
module or (
  input a,
  input b,
  output y
);
  assign y = a | b;
endmodule
module or #(parameter WIDTH = 1) (
  input  [WIDTH-1:0] a,
  input  [WIDTH-1:0] b,
  output [WIDTH-1:0] y
);
  assign y = a | b;
endmodule


// NOT gate module
module not (
  input a,
  output y
);
  assign y = ~a;
endmodule
module not #(parameter WIDTH = 1) (
  input  [WIDTH-1:0] a,
  output [WIDTH-1:0] y
);
  assign y = ~a;
endmodule


// D flip-flop module
module dff (
    input clk,
    input d,
    output reg q
);

    always @(posedge clk) begin
        q <= d;
    end

endmodule

// 3-input XNOR gate module
module xnor3 (
    input a,
    input b,
    input c,
    output y
);
  assign y = ~( (a ^ b) ^ c );
endmodule
module xnor3 #(parameter WIDTH = 1) (
  input  [WIDTH-1:0] a,
  input  [WIDTH-1:0] b,
  input  [WIDTH-1:0] c,
  output [WIDTH-1:0] y
);
  assign y = ~( (a ^ b) ^ c );
endmodule