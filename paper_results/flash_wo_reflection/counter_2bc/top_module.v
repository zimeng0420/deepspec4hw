module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output logic [1:0] state
);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    // Increment, saturate at 3
                    if (state == 2'b11) begin
                        state <= 2'b11;
                    end else begin
                        state <= state + 1;
                    end
                end else begin
                    // Decrement, saturate at 0
                    if (state == 2'b00) begin
                        state <= 2'b00;
                    end else begin
                        state <= state - 1;
                    end
                end
            end else begin
                // Hold value
                state <= state;
            end
        end
    end

endmodule