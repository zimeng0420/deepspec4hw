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
        Q <= R; // Load value
    end else if (E) begin
        Q <= w; // Shift value
    end // If both L and E are low, Q retains its previous value
endmodule