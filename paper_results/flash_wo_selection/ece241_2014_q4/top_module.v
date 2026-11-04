module top_module (
    input clk,
    input x,
    output z
);

    reg q1, q2, q3;
    wire q2_bar, q3_bar;
    wire xor_out, and_out, or_out;

    // Complement of q2 and q3
    assign q2_bar = ~q2;
    assign q3_bar = ~q3;

    // XOR, AND, and OR gates
    assign xor_out = x ^ q1;
    assign and_out = x & q2_bar;
    assign or_out = x | q3_bar;

    // D flip-flops
    always @(posedge clk) begin
        q1 <= xor_out;
        q2 <= and_out;
        q3 <= or_out;
    end

    // Three-input XNOR gate
    assign z = ~((q1 ^ q2) ^ q3);

endmodule