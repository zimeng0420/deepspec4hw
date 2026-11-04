module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output logic [1:0] state
);

    logic [1:0] next_state;

    always_ff @ (posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // Reset to weakly not-taken
        end else begin
            state <= next_state; // Update state
        end
    end

    always_comb begin
        // Default to current state
        next_state = state;

        if (train_valid) begin
            if (train_taken) begin
                // Increment logic with saturation
                if (state < 2'b11) begin
                    next_state = state + 1;
                end
            end else begin
                // Decrement logic with saturation
                if (state > 2'b00) begin
                    next_state = state - 1;
                end
            end
        end
    end

endmodule