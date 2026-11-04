module top_module (
	input clk,
	input x,
	output z
);

    // Internal signals
    wire xor_in, and_in, or_in;
    wire q1, q2, q3, q1_n, q2_n, q3_n;

    // XOR gate and D flip-flop
    xor #(1) xor_gate (
        .in1(x),
        .in2(q1),
        .out(xor_in)
    );

    dff dff_xor (
        .clk(clk),
        .d(xor_in),
        .q(q1)
    );

    // AND gate and D flip-flop
    not #(1) not_q2 (
        .in(q2),
        .out(q2_n)
    );

    and #(1) and_gate (
        .in1(x),
        .in2(q2_n),
        .out(and_in)
    );

    dff dff_and (
        .clk(clk),
        .d(and_in),
        .q(q2)
    );

    // OR gate and D flip-flop
    not #(1) not_q3 (
        .in(q3),
        .out(q3_n)
    );

    or #(1) or_gate (
        .in1(x),
        .in2(q3_n),
        .out(or_in)
    );

    dff dff_or (
        .clk(clk),
        .d(or_in),
        .q(q3)
    );

    // XNOR gate
    xnor #(1) xnor_gate (
        .in1(q1),
        .in2(q2),
        .in3(q3),
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

module xnor (
    input in1,
    input in2,
    input in3,
    output out
);
    assign out = ~( (in1 ^ in2) ^ in3 );
endmodule