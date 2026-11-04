module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    // (1) Calculate out_both
    genvar i;
    generate
        for (i = 0; i < 99; i = i + 1) begin : both_calc
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    // (2) Calculate out_any
    generate
        for (i = 1; i < 100; i = i + 1) begin : any_calc
            assign out_any[i] = in[i] | in[i-1];
        end
    endgenerate

    // (3) Calculate out_different
    assign out_different[99] = in[99] ^ in[0];  // For wrapping around case
    generate
        for (i = 0; i < 99; i = i + 1) begin : different_calc
            assign out_different[i] = in[i] ^ in[i+1];
        end
    endgenerate

endmodule