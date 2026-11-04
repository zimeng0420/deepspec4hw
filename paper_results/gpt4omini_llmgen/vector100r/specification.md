```verilog
module top_module (
    input [99:0] in,
    output reg [99:0] out
);

    integer i; // Declare an integer for use in the loop

    always @(*) begin
        // Reverse the bit ordering of the input vector
        for (i = 0; i < 100; i = i + 1) begin
            out[i] = in[99 - i];
        end
    end

endmodule
```