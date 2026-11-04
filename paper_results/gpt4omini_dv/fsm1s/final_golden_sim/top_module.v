module top_module (
    input clk,
    input in,
    input reset,
    output reg out
);

    reg state; // 0 for A, 1 for B

    always @(posedge clk) begin
        if (reset) begin
            state <= 1; // Reset to state B
        end else begin
            case (state)
                0: begin // State A
                    if (in == 0) state <= 1; // A -> B
                    // Stay in A if in == 1
                end
                1: begin // State B
                    if (in == 0) state <= 0; // B -> A
                    // Stay in B if in == 1
                end
            endcase
        end
    end

    always @(state) begin
        out = state; // out is 1 when in state B, 0 when in state A
    end

endmodule