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
            state_A <= (state_A & ~x) | (state_B & ~x); // Stay in A or remain in B
            state_B <= (state_A & x) | (state_B & x);   // Transition to B or remain in B
        end
    end
endmodule