module top_module (
    input [254:0] in,
    output reg [7:0] out
);

    integer i;
    always @(*) begin
        out = 0; // Initialize output to 0
        for (i = 0; i < 255; i = i + 1) begin
            out = out + in[i]; // Increment output for every '1' in the input vector
        end
    end

endmodule