module top_module(
    input clk,
    input reset,
    output reg [3:1] ena,
    output reg [15:0] q
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'b0000_0000_0000_0000;
            ena <= 3'b000;
        end else begin
            if (q[3:0] == 4'b1001) begin
                q[3:0] <= 4'b0000;
                ena[1] <= 1;
                if (q[7:4] == 4'b1001) begin
                    q[7:4] <= 4'b0000;
                    ena[2] <= 1;
                    if (q[11:8] == 4'b1001) begin
                        q[11:8] <= 4'b0000;
                        ena[3] <= 1;
                        if (q[15:12] == 4'b1001) begin
                            q[15:12] <= 4'b0000;
                        end else begin
                            q[15:12] <= q[15:12] + 1;
                        end
                    end else begin
                        q[11:8] <= q[11:8] + 1;
                    end
                end else begin
                    q[7:4] <= q[7:4] + 1;
                end
            end else begin
                q[3:0] <= q[3:0] + 1;
            end
            ena <= {q[7:4] != 4'b0000, q[11:8] != 4'b0000, q[15:12] != 4'b0000};
        end
    end
endmodule