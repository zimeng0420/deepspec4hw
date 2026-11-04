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

    // Complement outputs of flip-flops 2 and 3
    assign q2_n = ~q2;
    assign q3_n = ~q3;

    // Combinational logic
    assign xor_out = x ^ q1;
    assign and_out = x & q2_n;
    assign or_out = x | q3_n;
    assign z = ~(q1 ^ q2 ^ q3);

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