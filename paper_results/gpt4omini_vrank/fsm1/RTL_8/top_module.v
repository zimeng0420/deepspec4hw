module top_module (
    input clk,
    input in,
    input areset,
    output reg out
);
    reg state; // 0 for state A, 1 for state B

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1; // Reset to state B
        end else begin
            case (state)
                0: begin // State A
                    if (in == 0) begin
                        state <= 1; // Transition to state B
                    end
                    // else stay in state A
                end
                1: begin // State B
                    if (in == 0) begin
                        state <= 0; // Transition to state A
                    end
                    // else stay in state B
                end
            endcase
        end
    end

    always @(state) begin
        out = state; // Output is the current state
    end
endmodule