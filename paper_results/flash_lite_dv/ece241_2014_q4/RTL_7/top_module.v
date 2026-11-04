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
    wire q2_n, q3_n;

    // XOR gate
    xor xor_gate (
        .in1(x),
        .in2(q1),
        .out(xor_out)
    );

    // AND gate
    not not_q2 (
        .in(q2),
        .out(q2_n)
    );

    and and_gate (
        .in1(x),
        .in2(q2_n),
        .out(and_out)
    );

    // OR gate
    not not_q3 (
        .in(q3),
        .out(q3_n)
    );

    or or_gate (
        .in1(x),
        .in2(q3_n),
        .out(or_out)
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
    xnor xnor_gate1 (
        .in1(q1),
        .in2(q2),
        .out(xnor_out)
    );
    xnor xnor_gate2 (
        .in1(xnor_out),
        .in2(q3),
        .out(z)
    );

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

// XOR gate module
module xor (
    input in1,
    input in2,
    output out
);
    assign out = in1 ^ in2;
endmodule

// AND gate module
module and (
    input in1,
    input in2,
    output out
);
    assign out = in1 & in2;
endmodule

// OR gate module
module or (
    input in1,
    input in2,
    output out
);
    assign out = in1 | in2;
endmodule

// XNOR gate module
module xnor (
    input in1,
    input in2,
    output out
);
    assign out = ~(in1 ^ in2);
endmodule

// NOT gate module
module not (
    input in,
    output out
);
    assign out = ~in;
endmodule