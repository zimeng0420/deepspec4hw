module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            q <= 3'b100; // Set q to 4 when a is 1
        end else begin
            q <= (q == 3'b111) ? 3'b000 : q + 1; // Increment q and wrap at 7
        end
    end

endmodule