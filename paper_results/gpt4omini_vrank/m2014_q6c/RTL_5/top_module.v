module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4
);

wire A = y[1];
wire B = y[2];
wire C = y[3];
wire D = y[4];
wire E = y[5];
wire F = y[6];

// Y2 logic expression
assign Y2 = (B & ~w) | (C & ~w) | (D & ~w) | (F & w);

// Y4 logic expression
assign Y4 = (A & w) | (C & ~w) | (D & ~w) | (E & w);

endmodule