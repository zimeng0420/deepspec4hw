module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);

    reg state; // 0 = A, 1 = B

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1; // Reset to state B
        end else begin
            case (state)
                0: begin // State A
                    if (in == 0) begin
                        state <= 1; // Transition to State B
                    end else begin
                        state <= 0; // Remain in State A
                    end
                end
                1: begin // State B
                    if (in == 0) begin
                        state <= 0; // Transition to State A
                    end else begin
                        state <= 1; // Remain in State B
                    end
                end
            endcase
        end
    end

    always @(state) begin
        out <= state; // Output is the current state (0 or 1)
    end

endmodule