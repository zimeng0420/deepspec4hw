module top_module(
    input clk,
    input reset,
    output [3:1] ena,
    output reg [15:0] q
);

    // Determine when to enable each digit
    assign ena[1] = (q[3:0] == 4'd9);        // Enable tens digit when ones digit overflows
    assign ena[2] = (q[7:4] == 4'd9) & ena[1];  // Enable hundreds digit when tens digit overflows
    assign ena[3] = (q[11:8] == 4'd9) & ena[2]; // Enable thousands digit when hundreds digit overflows

    always @(posedge clk) begin
        if (reset) begin
            q <= 16'b0;  // Synchronous reset to 0000
        end else begin
            // Increment the ones place
            if (q[3:0] < 4'd9) begin
                q[3:0] <= q[3:0] + 1'b1;
            end else begin
                q[3:0] <= 4'd0;

                // Increment the tens place
                if (ena[1]) begin
                    if (q[7:4] < 4'd9) begin
                        q[7:4] <= q[7:4] + 1'b1;
                    end else begin
                        q[7:4] <= 4'd0;

                        // Increment the hundreds place
                        if (ena[2]) begin
                            if (q[11:8] < 4'd9) begin
                                q[11:8] <= q[11:8] + 1'b1;
                            end else begin
                                q[11:8] <= 4'd0;

                                // Increment the thousands place
                                if (ena[3]) begin
                                    if (q[15:12] < 4'd9) begin
                                        q[15:12] <= q[15:12] + 1'b1;
                                    end else begin
                                        q[15:12] <= 4'd0; // Wrap around if it reaches 9999
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