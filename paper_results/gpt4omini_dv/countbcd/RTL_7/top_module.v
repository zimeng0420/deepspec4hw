module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0;
        end else begin
            // Ones digit
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'b0;
                ena[1] <= 1'b1; // Enable tens increment
            end else begin
                q[3:0] <= q[3:0] + 1;
                ena[1] <= 1'b0; // Disable tens increment
            end
            
            // Tens digit
            if (ena[1] && q[7:4] == 4'd9) begin
                q[7:4] <= 4'b0;
                ena[2] <= 1'b1; // Enable hundreds increment
            end else if (ena[1]) begin
                q[7:4] <= q[7:4] + 1;
                ena[2] <= 1'b0; // Disable hundreds increment
            end
            
            // Hundreds digit
            if (ena[2] && q[11:8] == 4'd9) begin
                q[11:8] <= 4'b0;
                ena[3] <= 1'b1; // Enable thousands increment
            end else if (ena[2]) begin
                q[11:8] <= q[11:8] + 1;
                ena[3] <= 1'b0; // Disable thousands increment
            end
            
            // Thousands digit
            if (ena[3] && q[15:12] == 4'd9) begin
                q[15:12] <= 4'b0;
            end else if (ena[3]) begin
                q[15:12] <= q[15:12] + 1;
            end
        end
    end
endmodule