module top_module (
    input [99:0] in,
    output [98:0] out_both,
    output [99:1] out_any,
    output [99:0] out_different
);

    // Output for both neighboring bits are 1
    assign out_both = in[99:1] & in[98:0];
    
    // Output for any of the neighboring bits is 1
    assign out_any = in[1:99] | in[0:98];
    
    // Output for differing neighboring bits
    assign out_different = in ^ {in[0], in[99:1]};

endmodule