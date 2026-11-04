module top_module (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    assign out_and = &in;
    assign out_or = |in;

    wire xor_temp [98:0];
    assign xor_temp[0] = in[0] ^ in[1];
    generate
        genvar i;
        for (i = 1; i < 99; i = i + 1) begin
            assign xor_temp[i] = xor_temp[i-1] ^ in[i+1];
        end
    endgenerate

    assign out_xor = xor_temp[98];

endmodule