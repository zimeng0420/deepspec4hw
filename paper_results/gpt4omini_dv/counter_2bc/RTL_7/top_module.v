module top_module(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output logic [1:0] state
);

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01; // Reset to weakly not-taken
        end else if (train_valid) begin
            if (train_taken) begin
                case (state)
                    2'b00: state <= 2'b01;
                    2'b01: state <= 2'b10;
                    2'b10: state <= 2'b11;
                    2'b11: state <= 2'b11; // Saturation
                endcase
            end else begin
                case (state)
                    2'b00: state <= 2'b00; // Saturation at 0
                    2'b01: state <= 2'b00;
                    2'b10: state <= 2'b01;
                    2'b11: state <= 2'b10;
                endcase
            end
        end
    end

endmodule