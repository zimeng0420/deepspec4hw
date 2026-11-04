module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    // Compute out_both: AND between in[i] and in[i+1] for each i from 0 to 98
    assign out_both = in[98:0] & in[99:1];
    
    // Compute out_any: OR between in[i] and in[i-1] for each i from 1 to 99
    assign out_any = in[99:1] | in[98:0];
    
    // Compute out_different: XOR between in[i] and in[i+1], with wrap-around at the end
    assign out_different = in ^ {in[0], in[99:1]};

endmodule