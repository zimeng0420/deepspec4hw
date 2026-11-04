module top_module (
	input clk,
	input x,
	output z
);

    // Internal signals
    wire xor_out;
    wire and_out;
    wire or_out;
    wire q_xor;
    wire q_and;
    wire q_or;
    wire q_and_n;
    wire q_or_n;

    // XOR gate and D flip-flop
    xor_gate xor_inst (
        .in1(x),
        .in2(q_xor),
        .out(xor_out)
    );

    dff_posedge_rst xor_dff_inst (
        .clk(clk),
        .rst(1'b0), // Assuming reset is implicit, not explicitly given in the original description.
        .d(xor_out),
        .q(q_xor)
    );

    // AND gate and D flip-flop
    not_gate not_and_inst (
        .in(q_and),
        .out(q_and_n)
    );

    and_gate and_inst (
        .in1(x),
        .in2(q_and_n),
        .out(and_out)
    );

    dff_posedge_rst and_dff_inst (
        .clk(clk),
        .rst(1'b0),
        .d(and_out),
        .q(q_and)
    );

    // OR gate and D flip-flop
    not_gate not_or_inst (
        .in(q_or),
        .out(q_or_n)
    );

    or_gate or_inst (
        .in1(x),
        .in2(q_or_n),
        .out(or_out)
    );


    dff_posedge_rst or_dff_inst (
        .clk(clk),
        .rst(1'b0),
        .d(or_out),
        .q(q_or)
    );


    // XNOR gate
    xnor_gate xnor_inst (
        .in1(q_xor),
        .in2(q_and),
        .in3(q_or),
        .out(z)
    );

endmodule

// XOR Gate
module xor_gate (
    input in1,
    input in2,
    output out
);
    assign out = in1 ^ in2;
endmodule

// AND Gate
module and_gate (
    input in1,
    input in2,
    output out
);
    assign out = in1 & in2;
endmodule

// OR Gate
module or_gate (
    input in1,
    input in2,
    output out
);
    assign out = in1 | in2;
endmodule

// NOT Gate
module not_gate (
    input in,
    output out
);
    assign out = ~in;
endmodule

// XNOR Gate
module xnor_gate (
    input in1,
    input in2,
    input in3,
    output out
);
    assign out = ~( (in1 ^ in2) ^ in3 );
endmodule

// D flip-flop with positive edge clock and implicit reset
module dff_posedge_rst (
    input clk,
    input rst,
    input d,
    output reg q
);
    always @(posedge clk) begin
        if (rst)
            q <= 1'b0;  // synchronous reset - reset is assumed to be active high and implicit.
        else
            q <= d;
    end
endmodule