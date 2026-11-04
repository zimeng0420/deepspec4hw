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
            Q <= R;          // Load operation: When L=1, load R into Q
        else if (E) 
            Q <= w;          // Shift operation: When L=0 and E=1, shift w into Q
        else 
            Q <= Q;          // Hold operation: Retain current value of Q
    end

endmodule