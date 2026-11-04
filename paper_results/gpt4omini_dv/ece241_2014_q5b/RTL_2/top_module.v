module top_module (
    input clk,
    input areset,
    input x,
    output z
);
    // State encoding
    reg state_A, state_B;
    
    // Output logic
    assign z = (state_A && ~x) || (state_B && x);

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1; // Reset to state A
            state_B <= 1'b0;
        end else begin
            case ({state_A, state_B})
                2'b10: begin // State A
                    state_A <= (x) ? 1'b0 : 1'b1; // Stay in A or go to B
                    state_B <= (x) ? 1'b1 : 1'b0;
                end
                2'b01: begin // State B
                    state_A <= (x) ? 1'b0 : 1'b0; // Stay in B
                    state_B <= (x) ? 1'b0 : 1'b1;
                end
            endcase
        end
    end
endmodule