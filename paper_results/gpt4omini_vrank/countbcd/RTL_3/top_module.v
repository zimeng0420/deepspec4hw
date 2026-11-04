module top_module(
    input clk,
    input reset,
    output reg [3:1] ena,
    output reg [15:0] q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0; // Reset all digits to 0
            ena <= 3'b000;
        end else begin
            // BCD Counter Logic
            if (q[3:0] == 9) begin
                q[3:0] <= 0; // Reset ones digit
                ena[1] <= 1; // Enable tens digit increment
                if (q[7:4] == 9) begin
                    q[7:4] <= 0; // Reset tens digit
                    ena[2] <= 1; // Enable hundreds digit increment
                    if (q[11:8] == 9) begin
                        q[11:8] <= 0; // Reset hundreds digit
                        ena[3] <= 1; // Enable thousands digit increment
                        if (q[15:12] == 9) begin
                            q[15:12] <= 0; // Reset thousands digit
                        end else begin
                            q[15:12] <= q[15:12] + 1; // Increment thousands digit
                        end
                    end else begin
                        q[11:8] <= q[11:8] + 1; // Increment hundreds digit
                    end
                end else begin
                    q[7:4] <= q[7:4] + 1; // Increment tens digit
                end
            end else begin
                q[3:0] <= q[3:0] + 1; // Increment ones digit
            end
            
            // Update enable signals
            ena[1] <= (q[3:0] == 9);
            ena[2] <= (q[7:4] == 9 && q[3:0] == 9);
            ena[3] <= (q[11:8] == 9 && q[7:4] == 9 && q[3:0] == 9);
        end
    end
endmodule