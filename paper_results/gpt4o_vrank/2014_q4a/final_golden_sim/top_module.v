module top_module (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    always @(posedge clk) begin
        if (L) begin
            Q <= R; // Load value R to Q
        end else if (E) begin
            Q <= w; // Shift input w to Q
        end
    end

endmodule