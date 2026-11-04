module top_module (
	input clk,
	input x,
	output z
);

    wire xor_in, and_in, or_in;
    wire xor_out, and_out, or_out;
    wire q_xor, q_and, q_or;
    wire q_and_n, q_or_n;


    // XOR gate
    xor #(1) u_xor (
        .in1(x),
        .in2(q_xor),
        .out(xor_in)
    );

    // AND gate
    and #(1) u_and (
        .in1(x),
        .in2(q_and_n),
        .out(and_in)
    );

    // OR gate
    or #(1) u_or (
        .in1(x),
        .in2(q_or_n),
        .out(or_in)
    );


    // D flip-flop for XOR
    always @(posedge clk) begin
        q_xor <= xor_in;
    end

    // D flip-flop for AND
    always @(posedge clk) begin
        q_and <= and_in;
    end

    // D flip-flop for OR
    always @(posedge clk) begin
        q_or <= or_in;
    end


    // Complement of q_and
    not #(1) u_not_and (
        .in(q_and),
        .out(q_and_n)
    );

    // Complement of q_or
    not #(1) u_not_or (
        .in(q_or),
        .out(q_or_n)
    );


    // XNOR gate
    xnor3 #(1) u_xnor (
        .in1(q_xor),
        .in2(q_and),
        .in3(q_or),
        .out(z)
    );
endmodule


module xor #(parameter WIDTH = 1) (
  input [WIDTH-1:0] in1,
  input [WIDTH-1:0] in2,
  output [WIDTH-1:0] out
);
  assign out = in1 ^ in2;
endmodule


module and #(parameter WIDTH = 1) (
  input [WIDTH-1:0] in1,
  input [WIDTH-1:0] in2,
  output [WIDTH-1:0] out
);
  assign out = in1 & in2;
endmodule


module or #(parameter WIDTH = 1) (
  input [WIDTH-1:0] in1,
  input [WIDTH-1:0] in2,
  output [WIDTH-1:0] out
);
  assign out = in1 | in2;
endmodule



module xnor3 #(parameter WIDTH = 1) (
  input [WIDTH-1:0] in1,
  input [WIDTH-1:0] in2,
  input [WIDTH-1:0] in3,
  output [WIDTH-1:0] out
);
  assign out = ~(in1 ^ in2 ^ in3);
endmodule