module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        if (q == 0) begin
            q <= 4; // Initial state when a=1 and q=0
        end else if (q == 4) begin
            q <= 4; // Maintain state
        end else if (q == 5) begin
            q <= 6; // Increment from 5 to 6
        end else if (q == 6) begin
            q <= 0; // Reset on clock cycle from 6 to 0
        end else if (q == 1) begin
            q <= 0; // Reset to 0 from 1
        end 
    end else begin
        if (q == 4) begin
            q <= 4; // Maintain state when a=0
        end else if (q == 5) begin
            q <= 5; // Maintain state when a=0
        end else if (q == 6) begin
            q <= 6; // Maintain state when a=0
        end else if (q == 0) begin
            q <= 0; // Maintain state when a=0
        end else if (q == 1) begin
            q <= 1; // Maintain state when a=0
        end
    end
end

endmodule