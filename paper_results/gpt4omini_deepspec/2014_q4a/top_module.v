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
        Q <= R;  // Load the value from R when L is asserted
    end else if (E) begin
        Q <= w;  // Shift the value from w when E is asserted
    end // If neither L nor E are asserted, Q retains its previous value
end

endmodule