module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    reg z;
    reg state;

    localparam S_ZERO = 1'b0; // State before first '1'
    localparam S_ONE  = 1'b1; // State after first '1'

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_ZERO;
            z <= 1'b0;
        end else begin
            case (state)
                S_ZERO: begin
                    if (x == 1'b1) begin
                        state <= S_ONE;
                        z <= 1'b1;
                    end else begin
                        state <= S_ZERO;
                        z <= 1'b0;
                    end
                end
                S_ONE: begin
                    state <= S_ONE;
                    z <= ~x;
                end
                default: begin
                    state <= S_ZERO; // Default to zero on unexpected state
                    z <= 1'b0;
                end
            endcase
        end
    end

endmodule