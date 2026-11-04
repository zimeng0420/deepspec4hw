module top_module (
    input [255:0] in,     // 256-bit input vector
    input [7:0] sel,      // 8-bit select input for 256 inputs
    output out            // 1-bit output
);

    // MUX logic: select the output based on the value of 'sel'
    assign out = in[sel];

endmodule