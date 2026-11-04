module top_module(
    input clk,
    input [7:0] d,
    input reset,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b00000000; // Synchronous reset sets output to zero
        end else begin
            q <= d; // Load data on clock edge
        end
    end

endmodule