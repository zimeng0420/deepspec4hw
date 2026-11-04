module top_module(
    input clk,
    input reset,
    output reg [3:1] ena,
    output reg [15:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0;
            ena <= 3'b0;
        end else begin
            ena <= 3'b0; // Default to no enable
            
            // Increment Ones (q[3:0])
            if (q[3:0] == 4'b1001) begin
                q[3:0] <= 4'b0000; // Reset ones
                ena[1] <= 1'b1; // Enable increment of tens on overflow
            end else begin
                q[3:0] <= q[3:0] + 1'b1; // Increment ones
            end
            
            // Increment Tens (q[7:4])
            if (ena[1]) begin
                if (q[7:4] == 4'b1001) begin
                    q[7:4] <= 4'b0000; // Reset tens
                    ena[2] <= 1'b1; // Enable increment of hundreds on overflow
                end else begin
                    q[7:4] <= q[7:4] + 1'b1; // Increment tens
                end
            end
            
            // Increment Hundreds (q[11:8])
            if (ena[2]) begin
                if (q[11:8] == 4'b1001) begin
                    q[11:8] <= 4'b0000; // Reset hundreds
                    ena[3] <= 1'b1; // Enable increment of thousands on overflow
                end else begin
                    q[11:8] <= q[11:8] + 1'b1; // Increment hundreds
                end
            end
            
            // Increment Thousands (q[15:12])
            if (ena[3]) begin
                if (q[15:12] == 4'b1001) begin
                    q[15:12] <= 4'b0000; // Reset thousands
                end else begin
                    q[15:12] <= q[15:12] + 1'b1; // Increment thousands
                end
            end
        end
    end
endmodule