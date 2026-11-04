module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

    // Enable signal generation
    assign ena[1] = (q[3:0] == 4'd9);            // Enable for tens digit
    assign ena[2] = ena[1] && (q[7:4] == 4'd9);  // Enable for hundreds digit
    assign ena[3] = ena[2] && (q[11:8] == 4'd9); // Enable for thousands digit
    
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0; // Synchronous reset: reset all digits to 0
        end
        else begin
            // Ones digit
            if (q[3:0] < 4'd9) begin
                q[3:0] <= q[3:0] + 4'd1;
            end
            else begin
                q[3:0] <= 4'd0;
                
                // Tens digit
                if (ena[1]) begin
                    if (q[7:4] < 4'd9) begin
                        q[7:4] <= q[7:4] + 4'd1;
                    end
                    else begin
                        q[7:4] <= 4'd0;
                        
                        // Hundreds digit
                        if (ena[2]) begin
                            if (q[11:8] < 4'd9) begin
                                q[11:8] <= q[11:8] + 4'd1;
                            end
                            else begin
                                q[11:8] <= 4'd0;
                                
                                // Thousands digit
                                if (ena[3]) begin
                                    if (q[15:12] < 4'd9) begin
                                        q[15:12] <= q[15:12] + 4'd1;
                                    end
                                    else begin
                                        q[15:12] <= 4'd0;
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