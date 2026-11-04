module top_module(
    input clk,
    input slowena,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) 
        q <= 4'd0;              // Reset to 0 on reset signal
    else if (slowena) begin
        if (q == 4'd9)         // Check if the counter has reached 9
            q <= 4'd0;         // Reset to 0 after reaching 9
        else
            q <= q + 1;        // Increment the counter
    end
end

endmodule