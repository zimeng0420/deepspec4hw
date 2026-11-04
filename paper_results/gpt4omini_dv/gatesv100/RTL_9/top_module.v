module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);
    
    // out_both: Each bit indicates if in[i] and in[i + 1] are both '1'
    assign out_both[98] = in[98] & in[99];
    generate
        genvar i;
        for (i = 0; i < 98; i = i + 1) begin: both_logic
            assign out_both[i] = in[i] & in[i + 1];
        end
    endgenerate

    // out_any: Each bit indicates if in[i] or in[i - 1] is '1'
    generate
        for (i = 1; i < 100; i = i + 1) begin: any_logic
            assign out_any[i] = in[i] | in[i - 1];
        end
    endgenerate

    // out_different: Each bit indicates if in[i] is different from in[i - 1] with wrap-around
    assign out_different[0] = in[0] ^ in[99];
    generate
        for (i = 1; i < 100; i = i + 1) begin: different_logic
            assign out_different[i] = in[i] ^ in[i - 1];
        end
    endgenerate

endmodule