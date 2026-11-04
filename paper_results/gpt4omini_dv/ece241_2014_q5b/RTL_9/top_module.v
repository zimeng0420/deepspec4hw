module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg state_A, state_B;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1; // Reset to state A
            state_B <= 1'b0;
            z <= 1'b0; // Output z is 0 in state A
        end else begin
            case ({state_A, state_B})
                2'b10: begin // State A
                    if (x) begin
                        state_A <= 1'b0;
                        state_B <= 1'b1; // Go to state B
                        z <= 1'b1; // Output z is 1
                    end else begin
                        state_A <= 1'b1;
                        state_B <= 1'b0; // Stay in state A
                        z <= 1'b0; // Output z is 0
                    end
                end
                2'b01: begin // State B
                    if (x) begin
                        state_A <= 1'b0;
                        state_B <= 1'b1; // Stay in state B
                        z <= 1'b0; // Output z is 0
                    } else begin
                        state_A <= 1'b0;
                        state_B <= 1'b1; // Stay in state B
                        z <= 1'b1; // Output z is 1
                    end
                end
                default: begin
                    state_A <= 1'b0;
                    state_B <= 1'b0;
                    z <= 1'b0;
                end
            endcase
        end
    end
endmodule