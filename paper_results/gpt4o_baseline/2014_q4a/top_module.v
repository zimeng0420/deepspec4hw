module top_module (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    always @(posedge clk) begin
        if (L) 
            Q <= R;      // Load value R into Q if L is asserted
        else if (E) 
            Q <= w;      // Shift value w into Q if E is enabled
        // If neither L nor E is asserted, Q retains its previous value
    end

endmodule