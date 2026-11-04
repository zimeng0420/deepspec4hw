module top_module(
    input clk,
    input d,
    output reg q
);
    reg d1, d2;

    always @(posedge clk) begin
        d1 <= d;  // Capture d on rising edge
    end

    always @(negedge clk) begin
        d2 <= d;  // Capture d on falling edge
    end

    always @(posedge clk or negedge clk) begin
        if (clk) begin
            q <= d1; // Update output with the value captured on the rising edge
        end else begin
            q <= d2; // Update output with the value captured on the falling edge
        end
    end
endmodule