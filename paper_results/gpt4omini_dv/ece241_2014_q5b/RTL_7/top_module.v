module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    // State encoding
    reg state_A, state_B;

    // Output logic
    assign z = (state_A & ~x) | (state_B & x);

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1; // Reset to state A
            state_B <= 1'b0;
        end else begin
            // State transitions
            state_A <= (state_A & ~x) | (state_B & ~x);
            state_B <= (state_A & x) | (state_B & x);
        end
    end

endmodule