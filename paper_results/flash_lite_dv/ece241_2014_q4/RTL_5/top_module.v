module top_module(
    input clk,
    input x,
    output z
);

    // Internal signals
    wire xor_out, and_out, or_out;
    wire q1, q2, q3, q2_bar, q3_bar;

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

    // Complement outputs
    assign q2_bar = ~q2;
    assign q3_bar = ~q3;

    // Combinational logic
    assign xor_out = x ^ q1;
    assign and_out = x & q2_bar;
    assign or_out = x | q3_bar;
    assign z = ~(q1 ^ q2 ^ q3);  // XNOR implementation

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