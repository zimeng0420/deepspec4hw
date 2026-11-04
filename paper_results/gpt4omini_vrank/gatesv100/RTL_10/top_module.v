module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [98:0] out_any,
    output [99:0] out_different
);
    
    genvar i;
    
    generate
        for (i = 0; i < 99; i = i + 1) begin : both
            assign out_both[i] = in[i] & in[i + 1];
        end
        
        for (i = 1; i < 100; i = i + 1) begin : any
            assign out_any[i - 1] = in[i] | in[i - 1];
        end
        
        for (i = 0; i < 100; i = i + 1) begin : different
            assign out_different[i] = in[i] ^ in[(i + 1) % 100];
        end
    endgenerate

endmodule