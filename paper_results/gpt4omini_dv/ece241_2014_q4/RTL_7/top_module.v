module top_module (
    input clk,
    input x,
    output z
);

    reg DFF_XOR;
    reg DFF_AND;
    reg DFF_OR;
    
    wire Y_XOR;
    wire Y_AND;
    wire Y_OR;

    // Combinational Logic
    assign Y_XOR = x ^ DFF_XOR;
    assign Y_AND = x & ~DFF_AND;
    assign Y_OR = x | ~DFF_OR;

    // D Flip-Flops
    always @(posedge clk) begin
        DFF_XOR <= Y_XOR;
        DFF_AND <= Y_AND;
        DFF_OR <= Y_OR;
    end

    // Output Logic
    assign z = ~(DFF_XOR ^ DFF_AND ^ DFF_OR);

endmodule