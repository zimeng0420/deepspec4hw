module top_module (
    input clk,
    input x,
    output z
);

    reg dff1, dff2, dff3;

    wire xor_out, and_out, or_out;
    wire xnor_in1, xnor_in2, xnor_in3;

    assign xor_out = x ^ dff1;
    assign and_out = x & (~dff2);
    assign or_out  = x | (~dff3);

    always @(posedge clk) begin
        dff1 <= xor_out;
        dff2 <= and_out;
        dff3 <= or_out;
    end

    assign xnor_in1 = dff1;
    assign xnor_in2 = dff2;
    assign xnor_in3 = dff3;
    assign z = ~(xnor_in1 ^ xnor_in2 ^ xnor_in3); // Three-input XNOR implementation
    //Alternatively, z = (xnor_in1 & xnor_in2 & xnor_in3) | (~xnor_in1 & ~xnor_in2 & xnor_in3) | (~xnor_in1 & xnor_in2 & ~xnor_in3) | (xnor_in1 & ~xnor_in2 & ~xnor_in3);

endmodule