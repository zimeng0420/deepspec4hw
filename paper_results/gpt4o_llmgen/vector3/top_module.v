module top_module (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Concatenating the inputs and appending the two '1' bits
    wire [31:0] intermediate;
    assign intermediate = {a, b, c, d, e, f, 2'b11};

    // Splitting the intermediate vector into output vectors
    assign w = intermediate[31:24];
    assign x = intermediate[23:16];
    assign y = intermediate[15:8];
    assign z = intermediate[7:0];

endmodule