module top_module(
    input clk,
    input [7:0] d,
    input areset,
    output reg [7:0] q
);

    // Always block sensitive to the rising edge of clk or the areset signal
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset: set output to 0
            q <= 8'b0;
        end else begin
            // On the rising edge of clk, assign input d to output q
            q <= d;
        end
    end
    
endmodule