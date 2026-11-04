module top_module (
    input clk,
    input x,
    output z
);

    reg dff1, dff2, dff3;
    wire d1, d2, d3;
    wire not_dff1, not_dff2, not_dff3;
    wire xnor_in;

    assign d1 = x ^ dff1;
    assign not_dff1 = ~dff1;
    assign d2 = x & not_dff2;
    assign not_dff2 = ~dff2;
    assign d3 = x | not_dff3;
    assign not_dff3 = ~dff3;

    always @(posedge clk) begin
        dff1 <= d1;
        dff2 <= d2;
        dff3 <= d3;
    end

    assign xnor_in = ~(dff1 ^ dff2 ^ dff3);

    assign z = xnor_in;

endmodule