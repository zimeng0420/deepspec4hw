module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

    // Internal wire to decide when to enable incrementing next higher BCD digit
    wire ena1, ena2, ena3;

    // Assign enable signals based on current BCD digit values
    assign ena1 = (q[3:0] == 4'd9);
    assign ena2 = (q[7:4] == 4'd9) && ena1;
    assign ena3 = (q[11:8] == 4'd9) && ena2;

    // Output assignments for enable signals
    assign ena[1] = ena1;
    assign ena[2] = ena2;
    assign ena[3] = ena3;

    always @(posedge clk) begin
        if (reset) begin
            // Reset all BCD digits to 0 on reset
            q <= 16'd0;
        end else begin
            // Increment ones digit
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
                // Increment tens digit
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                    // Increment hundreds digit
                    if (q[11:8] == 4'd9) begin
                        q[11:8] <= 4'd0;
                        // Increment thousands digit
                        if (q[15:12] == 4'd9) begin
                            q[15:12] <= 4'd0;
                        end else begin
                            q[15:12] <= q[15:12] + 4'd1;
                        end
                    end else begin
                        q[11:8] <= q[11:8] + 4'd1;
                    end
                end else begin
                    q[7:4] <= q[7:4] + 4'd1;
                end
            end else begin
                q[3:0] <= q[3:0] + 4'd1;
            end
        end
    end
    
endmodule