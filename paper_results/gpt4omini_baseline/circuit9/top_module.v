module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            if (q == 3'b000) begin
                q <= 3'b100; // Initial condition when a=1
            end else if (q < 3'b111) begin
                q <= q + 1; // Increment q while a=1 and q < 7
            end
        end else begin
            if (q != 3'b000) begin
                q <= q - 1; // Decrement q while a=0 and q > 0
            end
        end
    end

endmodule