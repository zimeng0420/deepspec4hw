module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

    // Enable signals for upper digits
    assign ena[1] = (q[3:0] == 4'b1001); // Enable for tens when ones digit is 9
    assign ena[2] = (q[7:4] == 4'b1001); // Enable for hundreds when tens digit is 9
    assign ena[3] = (q[11:8] == 4'b1001); // Enable for thousands when hundreds digit is 9

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0; // Reset all digits to 0
        end else begin
            // Increment units place
            if (q[3:0] == 4'b1001) begin
                q[3:0] <= 4'd0; // Reset ones digit
                if (ena[1]) begin // Increment tens digit if enabled
                    if (q[7:4] == 4'b1001) begin
                        q[7:4] <= 4'd0; // Reset tens digit
                        if (ena[2]) begin // Increment hundreds digit if enabled
                            if (q[11:8] == 4'b1001) begin
                                q[11:8] <= 4'd0; // Reset hundreds digit
                                if (ena[3]) begin // Increment thousands digit if enabled
                                    q[15:12] <= q[15:12] + 4'd1; // Increment thousands digit
                                end
                            end else begin
                                q[11:8] <= q[11:8] + 4'd1; // Increment hundreds digit
                            end
                        end
                    end else begin
                        q[7:4] <= q[7:4] + 4'd1; // Increment tens digit
                    end
                end
            end else begin
                q[3:0] <= q[3:0] + 4'd1; // Increment ones digit
            end
        end
    end

endmodule