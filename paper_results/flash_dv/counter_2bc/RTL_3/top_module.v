module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output logic [1:0] state
);

    always_ff @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 2'b01;
        end else begin
            if (train_valid) begin
                if (train_taken) begin
                    // Increment
                    if (state == 2'b00) begin
                        state <= 2'b01;
                    end else if (state == 2'b01) begin
                        state <= 2'b10;
                    end else if (state == 2'b10) begin
                        state <= 2'b11;
                    end else begin
                        state <= 2'b11; // Saturate at 3
                    end
                end else begin
                    // Decrement
                    if (state == 2'b11) begin
                        state <= 2'b10;
                    end else if (state == 2'b10) begin
                        state <= 2'b01;
                    end else if (state == 2'b01) begin
                        state <= 2'b00;
                    end else begin
                        state <= 2'b00; // Saturate at 0
                    end
                end
            end // else state remains unchanged
        end
    end

endmodule