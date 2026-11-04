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
            state <= next_state; // Update to next state
        end
    end

    always_comb begin
        next_state = state; // Default to hold current state
        if (train_valid) begin
            if (train_taken) begin
                // Increment logic with saturation
                case (state)
                    2'b00: next_state = 2'b01;
                    2'b01: next_state = 2'b10;
                    2'b10: next_state = 2'b11;
                    2'b11: next_state = 2'b11; // Saturation
                endcase
            end else begin
                // Decrement logic with saturation
                case (state)
                    2'b00: next_state = 2'b00; // Saturation
                    2'b01: next_state = 2'b00;
                    2'b10: next_state = 2'b01;
                    2'b11: next_state = 2'b10;
                endcase
            end
        end
    end

endmodule