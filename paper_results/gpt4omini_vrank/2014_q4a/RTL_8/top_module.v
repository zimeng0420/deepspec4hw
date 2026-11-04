module top_module (
    input clk,
    input w,
    input [n-1:0] R,
    input E,
    input L,
    output reg Q
);
    always @(posedge clk) begin
        if (L) begin
            Q <= R; // Load value R into the register
        end else if (E) begin
            Q <= w; // Shift in value w
        end
    end
endmodule