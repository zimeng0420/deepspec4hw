module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
        end else begin
            // Increment the ones digit
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'd0;
                // Enable increment of the tens digit
                ena[1] <= 1'b1;
            end else begin
                q[3:0] <= q[3:0] + 4'd1;
                ena[1] <= 1'b0;
            end

            // Increment the tens digit if ena[1] is high
            if (ena[1]) begin
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'd0;
                    // Enable increment of the hundreds digit
                    ena[2] <= 1'b1;
                end else begin
                    q[7:4] <= q[7:4] + 4'd1;
                    ena[2] <= 1'b0;
                end
            end else begin
                ena[2] <= 1'b0;
            end

            // Increment the hundreds digit if ena[2] is high
            if (ena[2]) begin
                if (q[11:8] == 4'd9) begin
                    q[11:8] <= 4'd0;
                    // Enable increment of the thousands digit
                    ena[3] <= 1'b1;
                end else begin
                    q[11:8] <= q[11:8] + 4'd1;
                    ena[3] <= 1'b0;
                end
            end else begin
                ena[3] <= 1'b0;
            end

            // Increment the thousands digit if ena[3] is high
            if (ena[3]) begin
                if (q[15:12] == 4'd9) begin
                    q[15:12] <= 4'd0;
                end else begin
                    q[15:12] <= q[15:12] + 4'd1;
                end
            end
        end
    end
    
endmodule