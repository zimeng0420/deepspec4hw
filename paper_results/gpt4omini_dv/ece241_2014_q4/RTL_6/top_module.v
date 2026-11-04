module top_module (
    input clk,
    input x,
    output z
);
    reg DFF_XOR, DFF_AND, DFF_OR;
    wire Y_XOR, Y_AND, Y_OR;

    // Combinational logic
    assign Y_XOR = x ^ DFF_XOR;               // XOR gate
    assign Y_AND = x & ~DFF_AND;              // AND gate
    assign Y_OR  = x | ~DFF_OR;               // OR gate

    // D flip-flops
    always @(posedge clk) begin
        DFF_XOR <= Y_XOR;
        DFF_AND <= Y_AND;
        DFF_OR  <= Y_OR;
    end

    // Output logic
    assign z = ~(DFF_XOR ^ DFF_AND ^ DFF_OR); // XNOR gate

endmodule