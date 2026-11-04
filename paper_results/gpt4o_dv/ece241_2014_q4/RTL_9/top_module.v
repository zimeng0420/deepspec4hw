module top_module (
    input clk,
    input x,
    output reg z
);

    reg Q1, Q2, Q3;

    wire xor_out, and_out, or_out, xnor_out;

    assign xor_out = x ^ Q1;
    assign and_out = x & ~Q2;
    assign or_out = x | ~Q3;

    assign xnor_out = ~(xor_out ^ and_out ^ or_out);

    always @(posedge clk) begin
        Q1 <= xor_out;
        Q2 <= and_out;
        Q3 <= or_out;
        z <= xnor_out;
    end

endmodule