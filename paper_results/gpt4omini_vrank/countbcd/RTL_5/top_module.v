module top_module(
    input clk,
    input reset,
    output reg [3:1] ena,
    output reg [15:0] q
);
    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;
            ena <= 3'b0;
        end else begin
            ena <= 3'b0;
            // Ones digit
            if (q[3:0] == 4'b1001) begin
                q[3:0] <= 4'b0000;
                if (q[7:4] == 4'b1001) begin
                    q[7:4] <= 4'b0000;
                    if (q[11:8] == 4'b1001) begin
                        q[11:8] <= 4'b0000;
                        if (q[15:12] == 4'b1001) begin
                            q[15:12] <= 4'b0000; // Reset the highest digit
                        end else begin
                            q[15:12] <= q[15:12] + 4'b0001; // Increment the thousands digit
                        end
                    end else begin
                        q[11:8] <= q[11:8] + 4'b0001; // Increment the hundreds digit
                    end
                end else begin
                    q[7:4] <= q[7:4] + 4'b0001; // Increment the tens digit
                end
            end else begin
                q[3:0] <= q[3:0] + 4'b0001; // Increment the ones digit
            end

            // Enable signals
            ena[1] = (q[3:0] == 4'b0000) && (q[7:4] != 4'b1001); // Enable for tens digit
            ena[2] = (q[7:4] == 4'b0000) && (q[11:8] != 4'b1001); // Enable for hundreds digit
            ena[3] = (q[11:8] == 4'b0000) && (q[15:12] != 4'b1001); // Enable for thousands digit
        end
    end
endmodule