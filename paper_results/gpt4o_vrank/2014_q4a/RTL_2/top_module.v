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
            Q <= R; // Load the value R into the flip-flop
        end else if (E) begin
            Q <= w; // Shift the input w into the flip-flop
        end
        // If neither L nor E is asserted, retain the current value of Q
    end

endmodule