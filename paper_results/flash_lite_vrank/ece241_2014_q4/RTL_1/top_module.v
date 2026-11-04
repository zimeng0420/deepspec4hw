module top_module (
	input clk,
	input x,
	output z
);

    wire xor_in, and_in, or_in;
    wire q_xor, q_and, q_or;
    wire not_q_and, not_q_or;

    // XOR gate and flip-flop
    xor #(1) xor_gate (
        .a(x),
        .b(q_xor),
        .out(xor_in)
    );

    dff #(1) xor_ff (
        .clk(clk),
        .d(xor_in),
        .q(q_xor)
    );

    // AND gate and flip-flop
    not #(1) not_and (
        .in(q_and),
        .out(not_q_and)
    );

    and #(1) and_gate (
        .a(x),
        .b(not_q_and),
        .out(and_in)
    );

    dff #(1) and_ff (
        .clk(clk),
        .d(and_in),
        .q(q_and)
    );


    // OR gate and flip-flop
    not #(1) not_or (
        .in(q_or),
        .out(not_q_or)
    );

    or #(1) or_gate (
        .a(x),
        .b(not_q_or),
        .out(or_in)
    );

    dff #(1) or_ff (
        .clk(clk),
        .d(or_in),
        .q(q_or)
    );

    // XNOR gate
    xnor #(1) xnor_gate (
        .a(q_xor),
        .b(q_and),
        .c(q_or),
        .out(z)
    );
    
endmodule


module dff (
    input clk,
    input d,
    output reg q
);

    always @(posedge clk) begin
        q <= d;
    end

endmodule

module xor (
    input a,
    input b,
    output out
);
    assign out = a ^ b;
endmodule

module and (
    input a,
    input b,
    output out
);
    assign out = a & b;
endmodule

module or (
    input a,
    input b,
    output out
);
    assign out = a | b;
endmodule

module xnor (
    input a,
    input b,
    input c,
    output out
);
    assign out = ~( (a ^ b) ^ c);
endmodule


module not (
  input in,
  output out
);
  assign out = ~in;
endmodule