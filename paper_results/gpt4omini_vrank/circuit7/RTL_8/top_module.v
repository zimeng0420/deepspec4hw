module top_module (
    input clk,
    input a, 
    output reg q
);
    always @(posedge clk) begin
        if (a == 0) begin
            q <= q; // Hold state
        end else begin
            q <= ~q; // Toggle state
        end
    end
endmodule