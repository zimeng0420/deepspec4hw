module top_module (
    input [31:0] in,
    output [31:0] out
);

    assign out[31:24] = in[7:0];   // Byte 0 becomes Byte 3
    assign out[23:16] = in[15:8];  // Byte 1 becomes Byte 2
    assign out[15:8]  = in[23:16]; // Byte 2 becomes Byte 1
    assign out[7:0]   = in[31:24]; // Byte 3 becomes Byte 0

endmodule