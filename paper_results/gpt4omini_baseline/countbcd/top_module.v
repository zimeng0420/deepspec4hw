module top_module(
    input clk,
    input reset,
    output reg [3:1] ena,
    output reg [15:0] q
);
    // BCD digit max values
    localparam MAX_DIGIT = 9;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0;
            ena <= 3'b0;
        end else begin
            ena <= 3'b0; // Reset enable signals
            
            // Increment ones digit (q[3:0])
            if (q[3:0] == MAX_DIGIT) begin
                q[3:0] <= 4'b0000; // Reset ones digit
                ena[1] <= 1; // Enable increment of the tens digit
            end else begin
                q[3:0] <= q[3:0] + 1;
            end
            
            // Increment tens digit (q[7:4])
            if (ena[1]) begin
                if (q[7:4] == MAX_DIGIT) begin
                    q[7:4] <= 4'b0000; // Reset tens digit
                    ena[2] <= 1; // Enable increment of the hundreds digit
                end else begin
                    q[7:4] <= q[7:4] + 1;
                end
            end
            
            // Increment hundreds digit (q[11:8])
            if (ena[2]) begin
                if (q[11:8] == MAX_DIGIT) begin
                    q[11:8] <= 4'b0000; // Reset hundreds digit
                    ena[3] <= 1; // Enable increment of the thousands digit
                end else begin
                    q[11:8] <= q[11:8] + 1;
                end
            end
            
            // Increment thousands digit (q[15:12])
            if (ena[3]) begin
                if (q[15:12] == MAX_DIGIT) begin
                    q[15:12] <= 4'b0000; // Reset thousands digit
                end else begin
                    q[15:12] <= q[15:12] + 1;
                end
            end
        end
    end
endmodule