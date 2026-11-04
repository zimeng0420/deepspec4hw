module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output logic [1:0] state
);

    always_ff @(posedge clk, posedge areset) begin
        if (areset) begin
            // Asynchronous reset to weakly not-taken state
            state <= 2'b01;
        end
        else if (train_valid) begin
            if (train_taken) begin
                // Increment state if not at maximum (3)
                if (state != 2'b11) begin
                    state <= state + 1;
                end
                else begin
                    state <= state; // Remain at maximum
                end
            end
            else begin
                // Decrement state if not at minimum (0)
                if (state != 2'b00) begin
                    state <= state - 1;
                end
                else begin
                    state <= state; // Remain at minimum
                end
            end
        end
        else begin
            state <= state; // Hold state
        end
    end

endmodule