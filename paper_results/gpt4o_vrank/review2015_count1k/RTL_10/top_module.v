module top_module(
    input clk,
    input reset,
    output reg [9:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'b0; // Reset counter to 0
        end else begin
            if (q == 10'b1111100111) begin // Check if counter is 999
                q <= 10'b0; // Reset to 0 if it reaches 999
            end else begin
                q <= q + 1; // Increment counter
            end
        end
    end

endmodule