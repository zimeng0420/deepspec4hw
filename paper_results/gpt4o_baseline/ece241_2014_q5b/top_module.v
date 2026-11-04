module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // One-hot encoding: two states
    reg state_A, state_B;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset to state A
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            // State transitions
            case ({state_A, state_B})
                2'b10: begin // State A
                    if (x) begin
                        state_A <= 1'b0;
                        state_B <= 1'b1;
                    end else begin
                        state_A <= 1'b1;
                        state_B <= 1'b0;
                    end
                end
                2'b01: begin // State B
                    if (x) begin
                        state_A <= 1'b0;
                        state_B <= 1'b1;
                    end else begin
                        state_A <= 1'b0;
                        state_B <= 1'b1;
                    end
                end
                default: begin
                    // Should not happen
                    state_A <= 1'b0;
                    state_B <= 1'b0;
                end
            endcase
        end
    end

    // Output logic based on states
    always @(*) begin
        case ({state_A, state_B})
            2'b10: z = x;  // State A
            2'b01: z = ~x; // State B
            default: z = 1'b0; // Should not happen
        endcase
    end

endmodule