module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output logic [1:0] state
);

    logic [1:0] next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // Reset to weakly not-taken
        end else begin
            state <= next_state; // Update state
        end
    end

    always_comb begin
        // Default next state is the current state
        next_state = state;

        if (train_valid) begin
            if (train_taken) begin
                // Increment logic
                case (state)
                    2'b00: next_state = 2'b01;
                    2'b01: next_state = 2'b10;
                    2'b10: next_state = 2'b11;
                    2'b11: next_state = 2'b11; // Saturation
                endcase
            end else begin
                // Decrement logic
                case (state)
                    2'b00: next_state = 2'b00; // Saturation
                    2'b01: next_state = 2'b00;
                    2'b10: next_state = 2'b01;
                    2'b11: next_state = 2'b10;
                endcase
            end
        end
        // If train_valid is 0, next_state remains unchanged (hold state)
    end

endmodule