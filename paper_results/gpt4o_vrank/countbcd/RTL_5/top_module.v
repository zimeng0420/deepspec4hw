module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q);

    // Increment enable for each BCD digit
    assign ena[1] = (q[3:0] == 4'd9);        // Enable tens increment if ones digit is 9
    assign ena[2] = (q[7:4] == 4'd9) && ena[1]; // Enable hundreds if tens are 9 and ena[1] is set
    assign ena[3] = (q[11:8] == 4'd9) && ena[2]; // Enable thousands if hundreds are 9 and ena[2] is set

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'd0;
        end else begin
            // Ones digit increment
            if (q[3:0] == 4'd9) 
                q[3:0] <= 4'd0;
            else 
                q[3:0] <= q[3:0] + 1'd1;

            // Tens digit increment
            if (ena[1]) begin
                if (q[7:4] == 4'd9) 
                    q[7:4] <= 4'd0;
                else 
                    q[7:4] <= q[7:4] + 1'd1;
            end

            // Hundreds digit increment
            if (ena[2]) begin
                if (q[11:8] == 4'd9) 
                    q[11:8] <= 4'd0;
                else 
                    q[11:8] <= q[11:8] + 1'd1;
            end

            // Thousands digit increment
            if (ena[3]) begin
                if (q[15:12] == 4'd9) 
                    q[15:12] <= 4'd0;
                else 
                    q[15:12] <= q[15:12] + 1'd1;
            end
        end
    end
endmodule