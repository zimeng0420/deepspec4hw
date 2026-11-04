module top_module (
    input clk,
    input a, 
    output reg [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            q <= 3'd4; // When a=1, q is set to 4
        end else begin
            q <= (q + 1) % 8; // When a=0, q increments and wraps around after 7
        end
    end

endmodule