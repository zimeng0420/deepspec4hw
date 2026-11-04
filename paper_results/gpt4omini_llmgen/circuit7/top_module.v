module top_module (
    input clk,
    input a, 
    output reg q
);

    reg flag; // Intermediate flag to store state

    always @(posedge clk) begin
        if (a == 1'b1) begin
            if (flag == 1'b0) begin
                q <= 1'b1; // Set q to 1 if flag is 0 when a is 1
                flag <= 1'b1; // Update flag to indicate q has been set
            end else begin
                q <= 1'b0; // Reset q to 0 if flag is already 1
                flag <= 1'b1; // Keep flag as 1
            end
        end else begin
            q <= 1'b0; // Maintain q at 0 when a is 0
            flag <= 1'b0; // Reset flag when a is 0
        end
    end

endmodule