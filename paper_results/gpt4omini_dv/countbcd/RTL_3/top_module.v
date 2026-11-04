module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0; // Reset all digits to 0
        end else begin
            if (q[3:0] == 9) begin
                q[3:0] <= 0;  // Reset ones
                ena[1] <= 1;  // Enable tens
            end else begin
                q[3:0] <= q[3:0] + 1; // Increment ones
                ena[1] <= 0; // Disable tens
            end
            
            if (ena[1]) begin
                if (q[7:4] == 9) begin
                    q[7:4] <= 0; // Reset tens
                    ena[2] <= 1; // Enable hundreds
                end else begin
                    q[7:4] <= q[7:4] + 1; // Increment tens
                    ena[2] <= 0; // Disable hundreds
                end
            end
            
            if (ena[2]) begin
                if (q[11:8] == 9) begin
                    q[11:8] <= 0; // Reset hundreds
                    ena[3] <= 1; // Enable thousands
                end else begin
                    q[11:8] <= q[11:8] + 1; // Increment hundreds
                    ena[3] <= 0; // Disable thousands
                end
            end
            
            if (ena[3]) begin
                if (q[15:12] == 9) begin
                    q[15:12] <= 0; // Reset thousands
                end else begin
                    q[15:12] <= q[15:12] + 1; // Increment thousands
                end
            end
            
        end
    end

endmodule