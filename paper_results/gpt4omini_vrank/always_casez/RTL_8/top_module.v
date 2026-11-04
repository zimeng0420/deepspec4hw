module top_module (
    input [7:0] in,
    output reg [2:0] pos
);
    integer i;
    always @* begin
        pos = 3'd0; // Default to zero
        for (i = 0; i < 8; i = i + 1) begin
            if (in[i]) begin
                pos = i; // Report the first bit that is high
                break;
            end
        end
    end
endmodule