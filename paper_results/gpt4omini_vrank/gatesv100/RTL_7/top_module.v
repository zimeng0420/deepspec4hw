module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    genvar i;
    
    // Calculate out_both
    generate
        for (i = 0; i < 99; i = i + 1) begin : both
            assign out_both[i] = in[i] & in[i + 1];
        end
    endgenerate
    
    // Calculate out_any
    generate
        for (i = 1; i < 100; i = i + 1) begin : any
            assign out_any[i] = in[i - 1] | in[i];
        end
    endgenerate
    
    // Calculate out_different
    generate
        for (i = 0; i < 100; i = i + 1) begin : different
            assign out_different[i] = in[i] ^ in[(i + 1) % 100];
        end
    endgenerate

endmodule