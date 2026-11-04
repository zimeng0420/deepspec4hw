module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q);

    // Enable logic for each digit
    assign ena[1] = (q[3:0] == 4'd9);          // Enable tens when ones digit rolls over
    assign ena[2] = (q[7:4] == 4'd9) & ena[1]; // Enable hundreds when tens digit rolls over
    assign ena[3] = (q[11:8] == 4'd9) & ena[2];// Enable thousands when hundreds digit rolls over

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0; // Reset all digits
        end else begin
            // Ones digit logic
            if (q[3:0] == 4'd9)
                q[3:0] <= 4'd0;
            else
                q[3:0] <= q[3:0] + 4'd1;

            // Tens digit logic
            if (ena[1]) begin
                if (q[7:4] == 4'd9)
                    q[7:4] <= 4'd0;
                else
                    q[7:4] <= q[7:4] + 4'd1;
            end
      
            // Hundreds digit logic
            if (ena[2]) begin
                if (q[11:8] == 4'd9)
                    q[11:8] <= 4'd0;
                else
                    q[11:8] <= q[11:8] + 4'd1;
            end

            // Thousands digit logic
            if (ena[3]) begin
                if (q[15:12] == 4'd9)
                    q[15:12] <= 4'd0;
                else
                    q[15:12] <= q[15:12] + 4'd1;
            end
        end
    end

endmodule