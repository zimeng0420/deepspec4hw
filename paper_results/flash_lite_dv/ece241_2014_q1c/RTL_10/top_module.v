module top_module (
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);

    wire [7:0] sum;
    wire [8] carry;

    assign carry[0] = 1'b0; // Initial carry-in for LSB

    // Ripple-carry adder
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : adder_stage
            assign {carry[i+1], sum[i]} = a[i] + b[i] + carry[i];
        end
    endgenerate

    assign s = sum;

    // Overflow detection
    assign overflow = (a[7] == b[7]) && (a[7] != s[7]);

endmodule