module top_module (
    input clk,
    input x,
    output z
);

    reg DFF_XOR, DFF_AND, DFF_OR;

    wire Y_XOR, Y_AND, Y_OR;

    // Combinational Logic
    assign Y_XOR = x ^ DFF_XOR;              // XOR gate
    assign Y_AND = x & ~DFF_AND;             // AND gate
    assign Y_OR  = x | ~DFF_OR;              // OR gate

    // D Flip-Flops
    always @(posedge clk) begin
        DFF_XOR <= Y_XOR;                    // DFF for XOR
        DFF_AND <= Y_AND;                    // DFF for AND
        DFF_OR  <= Y_OR;                     // DFF for OR
    end

    // Output Logic
    assign z = ~(DFF_XOR ^ DFF_AND ^ DFF_OR); // XNOR gate

endmodule