module top_module (
    input clk,
    input areset,
    input x,
    output reg z
);

    // State encoding using one-hot encoding
    reg state_A, state_B;

    // Combinational logic to determine next state and output
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1; // Reset to state A
            state_B <= 1'b0;
            z <= 1'b0;
        end
        else begin
            case ({state_A, state_B})
                2'b10: begin // State A
                    z <= x;
                    if (x)
                        state_B <= 1'b1;
                    else
                        state_B <= 1'b0;
                    state_A <= ~x;
                end
                2'b01: begin // State B
                    z <= ~x;
                    state_B <= 1'b1;
                    state_A <= 1'b0;
                end
            endcase
        end
    end
endmodule