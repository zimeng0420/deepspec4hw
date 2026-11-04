module top_module (
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

    always @(posedge clk) begin
        // State transition logic based on inputs a and b
        if (a && b) begin
            q <= 1; // Transition to 1 when both inputs are high
        end else if (!a && b) begin
            q <= 0; // Transition to 0 when a is low and b is high
        end else if (a && !b) begin
            // Hold the previous state
            q <= q;
        end

        // Update state output
        state <= q;
    end

endmodule