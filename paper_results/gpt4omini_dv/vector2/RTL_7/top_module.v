module top_module (
    input [31:0] in,
    output [31:0] out
);

    assign out[31:24] = in[7:0];   // LSB of 'in' to MSB of 'out'
    assign out[23:16] = in[15:8];  // second LSB of 'in' to second MSB of 'out'
    assign out[15:8] = in[23:16];  // second MSB of 'in' to second LSB of 'out'
    assign out[7:0] = in[31:24];   // MSB of 'in' to LSB of 'out'

endmodule