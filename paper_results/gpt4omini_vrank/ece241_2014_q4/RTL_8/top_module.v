module top_module (
    input clk,
    input x,
    output z
);

    reg dff_out1, dff_out2, dff_out3;
    
    wire d1, d2, d3;
    wire not_dff_out1, not_dff_out2, not_dff_out3;

    assign not_dff_out1 = ~dff_out1;
    assign not_dff_out2 = ~dff_out2;
    assign not_dff_out3 = ~dff_out3;

    // XOR gate
    assign d1 = x ^ dff_out1;
    // AND gate
    assign d2 = x & not_dff_out2;
    // OR gate
    assign d3 = x | not_dff_out3;

    always @(posedge clk) begin
        dff_out1 <= d1;
        dff_out2 <= d2;
        dff_out3 <= d3;
    end

    // XNOR gate output
    assign z = ~(dff_out1 ^ dff_out2 ^ dff_out3);

endmodule