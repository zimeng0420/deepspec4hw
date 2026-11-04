module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);
    
    // Enable signals for tens, hundreds, and thousands
    assign ena[1] = (q[3:0] == 4'd9) ? 1'b1 : 1'b0; // Enable tens digit if ones digit is 9
    assign ena[2] = (q[7:4] == 4'd9) ? 1'b1 : 1'b0; // Enable hundreds digit if tens digit is 9
    assign ena[3] = (q[11:8] == 4'd9) ? 1'b1 : 1'b0; // Enable thousands digit if hundreds digit is 9

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0; // Reset all digits to 0
        end else begin
            // Ones digit increment
            if (q[3:0] < 4'd9) begin
                q[3:0] <= q[3:0] + 4'd1;
            end else begin
                q[3:0] <= 4'b0; // Reset ones to 0, enable tens count
                // Tens digit increment
                if (ena[1]) begin
                    if (q[7:4] < 4'd9) begin
                        q[7:4] <= q[7:4] + 4'd1;
                    end else begin
                        q[7:4] <= 4'b0; // Reset tens to 0, enable hundreds count
                        // Hundreds digit increment
                        if (ena[2]) begin
                            if (q[11:8] < 4'd9) begin
                                q[11:8] <= q[11:8] + 4'd1;
                            end else begin
                                q[11:8] <= 4'b0; // Reset hundreds to 0, enable thousands count
                                // Thousands digit increment
                                if (ena[3]) begin
                                    if (q[15:12] < 4'd9) begin
                                        q[15:12] <= q[15:12] + 4'd1;
                                    end else begin
                                        q[15:12] <= 4'b0; // Reset thousands to 0
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
endmodule