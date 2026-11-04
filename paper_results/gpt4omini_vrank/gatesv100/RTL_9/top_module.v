module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);
    genvar i;

    generate
        for (i = 0; i < 99; i = i + 1) begin: both_logic
            assign out_both[i] = in[i] & in[i+1];
        end

        for (i = 1; i < 100; i = i + 1) begin: any_logic
            assign out_any[i-1] = in[i] | in[i-1];
        end

        for (i = 0; i < 99; i = i + 1) begin: different_logic
            assign out_different[i] = (in[i] ^ in[i+1]);
        end
        assign out_different[99] = (in[99] ^ in[0]);
    endgenerate
endmodule