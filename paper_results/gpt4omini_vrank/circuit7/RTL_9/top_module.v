module top_module (
    input clk,
    input a, 
    output reg q
);
    always @(posedge clk) begin
        if (a == 1) begin
            q <= ~q; // Toggle q when a is 1
        end
    end
endmodule