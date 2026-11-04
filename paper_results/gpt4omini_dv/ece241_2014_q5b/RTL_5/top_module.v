module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state_A; // State A
    reg state_B; // State B

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1; // Reset to State A
            state_B <= 1'b0;
            z <= 1'b0; // z = 0 on reset
        end else begin
            // State transition logic
            case ({state_A, state_B})
                2'b10: begin // State A
                    if (x) begin
                        state_A <= 1'b0;
                        state_B <= 1'b1; // Transition to State B
                        z <= 1'b1; // z = 1
                    end else begin
                        z <= 1'b0; // z = 0
                    end
                end
                2'b01: begin // State B
                    z <= x ? 1'b0 : 1'b1; // z = 1 if x = 0, z = 0 if x = 1
                end
            endcase
        end
    end

endmodule