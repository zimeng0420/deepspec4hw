module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
        end else begin
            // Ones digit
            if (q[3:0] == 4'b1001) begin
                q[3:0] <= 4'b0000; // Reset ones to 0
                ena[1] <= 1'b1; // Enable tens digit
            end else begin
                q[3:0] <= q[3:0] + 1'b1; // Increment ones digit
                ena[1] <= 1'b0; // Disable tens digit
            end

            // Tens digit
            if (ena[1] && q[7:4] == 4'b1001) begin
                q[7:4] <= 4'b0000; // Reset tens to 0
                ena[2] <= 1'b1; // Enable hundreds digit
            end else if (ena[1]) begin
                q[7:4] <= q[7:4] + 1'b1; // Increment tens digit
                ena[2] <= 1'b0; // Disable hundreds digit
            end

            // Hundreds digit
            if (ena[2] && q[11:8] == 4'b1001) begin
                q[11:8] <= 4'b0000; // Reset hundreds to 0
                ena[3] <= 1'b1; // Enable thousands digit
            end else if (ena[2]) begin
                q[11:8] <= q[11:8] + 1'b1; // Increment hundreds digit
                ena[3] <= 1'b0; // Disable thousands digit
            end

            // Thousands digit
            if (ena[3] && q[15:12] == 4'b1001) begin
                q[15:12] <= 4'b0000; // Reset thousands to 0
            end else if (ena[3]) begin
                q[15:12] <= q[15:12] + 1'b1; // Increment thousands digit
            end
        end
    end
endmodule