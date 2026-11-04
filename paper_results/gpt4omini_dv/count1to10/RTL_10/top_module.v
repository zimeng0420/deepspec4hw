module top_module(
    input clk,
    input reset,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) 
            q <= 4'b0001; // Reset to 1
        else if (q < 4'b1010) 
            q <= q + 1; // Increment
        else 
            q <= 4'b0001; // Wrap around to 1 after 10
    end

endmodule