module top_module (
    input [99:0] in,
    output reg [99:0] out
);
    integer i;
    always @(*) begin
        out = 0; // Initialize output
        for (i = 0; i < 100; i = i + 1) begin
            out[i] = in[99 - i]; // Reverse the bits
        end
    end
endmodule