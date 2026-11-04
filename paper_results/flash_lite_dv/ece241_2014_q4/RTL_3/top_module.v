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

    // Instantiate D flip-flops
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

    // Invert q2 and q3
    not n2 (q2_not, q2);
    not n3 (q3_not, q3);


    // Combinational logic
    xor xor_gate (xor_out, x, q1);
    and and_gate (and_out, x, q2_not);
    or or_gate (or_out, x, q3_not);

    // XNOR gate for output z
    xnor xnor_gate1 (z, q1, q2, q3);


endmodule

// D flip-flop module
module dff(
    input clk,
    input d,
    output reg q
);

    always @(posedge clk) begin
        q <= d;
    end

endmodule

// XOR gate module (needed for some simulators)
module xor(
    output out,
    input a,
    input b
);
    assign out = a ^ b;
endmodule

// AND gate module (needed for some simulators)
module and(
    output out,
    input a,
    input b
);
    assign out = a & b;
endmodule

// OR gate module (needed for some simulators)
module or(
    output out,
    input a,
    input b
);
    assign out = a | b;
endmodule

// XNOR gate module (needed for some simulators)
module xnor(
    output out,
    input a,
    input b,
    input c
);
    assign out = ~(a ^ b ^ c);
endmodule

// NOT gate module
module not (
    output out,
    input in
);

    assign out = ~in;

endmodule