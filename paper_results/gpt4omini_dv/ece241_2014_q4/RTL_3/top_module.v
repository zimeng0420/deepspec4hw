module top_module (
    input clk,
    input x,
    output z
);
    reg DFF_XOR, DFF_AND, DFF_OR;
    wire Y_XOR, Y_AND, Y_OR;

    // Combinational logic
    assign Y_XOR = x ^ DFF_XOR;
    assign Y_AND = x & ~DFF_AND;
    assign Y_OR = x | ~DFF_OR;

    // Sequential logic for D flip-flops
    always @(posedge clk) begin
        DFF_XOR <= Y_XOR;
        DFF_AND <= Y_AND;
        DFF_OR <= Y_OR;
    end

    // XNOR gate for output z
    assign z = ~(DFF_XOR ^ DFF_AND ^ DFF_OR);
endmodule