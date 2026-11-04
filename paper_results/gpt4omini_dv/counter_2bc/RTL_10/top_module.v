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
            state <= 2'b01;
        end else begin
            state <= next_state;
        end
    end

    always_comb begin
        if (train_valid) begin
            if (train_taken) begin
                case (state)
                    2'b00: next_state = 2'b01;
                    2'b01: next_state = 2'b10;
                    2'b10: next_state = 2'b11;
                    2'b11: next_state = 2'b11; // Saturation
                endcase
            end else begin
                case (state)
                    2'b00: next_state = 2'b00; // Saturation
                    2'b01: next_state = 2'b00;
                    2'b10: next_state = 2'b01;
                    2'b11: next_state = 2'b10;
                endcase
            end
        end else begin
            next_state = state; // Hold state
        end
    end

endmodule