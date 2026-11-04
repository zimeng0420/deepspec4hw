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
            Q <= R; // Load the value from R when L is high
        end else if (E) begin
            Q <= w; // Shift the value from w when E is high and L is low
        end // If both L and E are low, Q retains its previous value
    end

endmodule