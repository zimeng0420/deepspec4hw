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
            Q <= R; // Load R into Q
        end else if (E) begin
            Q <= w; // Shift w into Q
        end // Else Q retains its previous value
    end

endmodule