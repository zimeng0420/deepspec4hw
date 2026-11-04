module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q);
    
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
        end
        else begin
            // increment ones place
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
                // signal to increment tens place
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                    // signal to increment hundreds place
                    if (q[11:8] == 4'd9) begin
                        q[11:8] <= 4'd0;
                        // signal to increment thousands place
                        if (q[15:12] == 4'd9) begin
                            q[15:12] <= 4'd0;
                        end
                        else begin
                            q[15:12] <= q[15:12] + 1;
                        end
                    end
                    else begin
                        q[11:8] <= q[11:8] + 1;
                    end
                end
                else begin
                    q[7:4] <= q[7:4] + 1;
                end
            end
            else begin
                q[3:0] <= q[3:0] + 1;
            end
        end

        // Enable signals
        ena[1] <= (q[3:0] == 4'd9);   // Enable tens increment when ones is 9
        ena[2] <= (ena[1] && q[7:4] == 4'd9);   // Enable hundreds increment
        ena[3] <= (ena[2] && q[11:8] == 4'd9);  // Enable thousands increment
    end

endmodule