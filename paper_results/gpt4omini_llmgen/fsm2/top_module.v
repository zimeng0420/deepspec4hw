module top_module (
    input clk,
    input j,
    input k,
    input areset,
    output reg out
);

    reg state; // 0: OFF, 1: ON

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0; // Reset to OFF
        end else begin
            case (state)
                1'b0: begin // OFF
                    if (j) 
                        state <= 1'b1; // Transition to ON
                end
                1'b1: begin // ON
                    if (k) 
                        state <= 1'b0; // Transition to OFF
                end
            endcase
        end
    end

    always @(state) begin
        out = state; // Output reflects the current state
    end

endmodule