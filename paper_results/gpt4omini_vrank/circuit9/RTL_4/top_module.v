module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);
    always @(posedge clk) begin
        if (a) begin
            if (q == 4) begin
                q <= 4; // Hold value at 4 when a is 1
            end else begin
                q <= q + 1; // Increment q while a is 1, and it's not 4
            end
        end else begin
            if (q == 4) begin
                q <= 4; // Keep q at 4 if a goes low while it is 4
            end else if (q < 7) begin
                q <= q + 1; // Increment q if it's less than 7 when a is 0
            end else begin
                q <= 0; // Reset q to 0 if it is 7
            end
        end
    end
endmodule