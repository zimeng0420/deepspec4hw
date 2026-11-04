module top_module(
    input clk,
    input reset,
    output reg [3:1] ena,
    output reg [15:0] q);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            q <= 16'h0000;
            ena <= 3'b000;
        end else begin
            ena <= 3'b000; // Default no enable
            if (q[3:0] == 4'd9) begin
                q[3:0] <= 4'b0000; // Reset ones
                ena[1] <= 1'b1; // Enable tens
                if (q[7:4] == 4'd9) begin
                    q[7:4] <= 4'b0000; // Reset tens
                    ena[2] <= 1'b1; // Enable hundreds
                    if (q[11:8] == 4'd9) begin
                        q[11:8] <= 4'b0000; // Reset hundreds
                        ena[3] <= 1'b1; // Enable thousands
                        if (q[15:12] < 4'd9) begin
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
        end
    end
endmodule