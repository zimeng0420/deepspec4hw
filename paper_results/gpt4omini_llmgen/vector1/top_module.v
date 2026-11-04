module top_module (
    input [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    assign out_hi = in[15:8]; // Assign upper byte
    assign out_lo = in[7:0];  // Assign lower byte

endmodule