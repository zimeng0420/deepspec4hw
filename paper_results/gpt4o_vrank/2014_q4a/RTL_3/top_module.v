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
            Q <= R;  // Load the register with the value R
        end else if (E) begin
            Q <= w;  // Shift the input value w into the register
        end
        // If neither L nor E is asserted, Q maintains its value
    end

endmodule