module top_module (
    input clk,
    input x,
    output z
);

    reg dff_a, dff_b, dff_c;
    wire a_xor, a_and, a_or;
    
    // D Flip-Flops
    always @(posedge clk) begin
        dff_a <= a_xor;
        dff_b <= a_and;
        dff_c <= a_or;
    end
    
    // Gates
    assign a_xor = x ^ dff_a;
    assign a_and = x & ~dff_b;
    assign a_or = x | ~dff_c;
    
    // XNOR output
    assign z = dff_a ~^ dff_b ~^ dff_c;

endmodule