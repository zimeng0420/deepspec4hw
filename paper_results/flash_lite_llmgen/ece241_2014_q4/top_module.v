module top_module (
    input clk,
    input x,
    output z
);

    // Internal signals
    wire xor_out;
    wire and_out;
    wire or_out;
    wire q2_bar;
    wire q3_bar;

    // D flip-flops
    reg q1;
    reg q2;
    reg q3;

    // Combinational logic
    assign xor_out = x ^ q1;
    assign q2_bar = ~q2;
    assign and_out = x & q2_bar;
    assign q3_bar = ~q3;
    assign or_out = x | q3_bar;
    assign z = ~(q1 ^ q2 ^ q3); // XNOR implementation

    // Sequential logic (D flip-flops)
    always @(posedge clk) begin
        q1 <= xor_out;
        q2 <= and_out;
        q3 <= or_out;
    end

endmodule