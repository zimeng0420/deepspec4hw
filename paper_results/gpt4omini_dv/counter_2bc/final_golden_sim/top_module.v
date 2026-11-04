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
            state <= next_state;
        end
    end

    always_comb begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment logic with saturation
                next_state = (state == 2'b11) ? 2'b11 : state + 1;
            end else begin
                // Decrement logic with saturation
                next_state = (state == 2'b00) ? 2'b00 : state - 1;
            end
        end else begin
            next_state = state; // Hold state
        end
    end
endmodule