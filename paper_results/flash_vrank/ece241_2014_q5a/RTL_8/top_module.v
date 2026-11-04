module top_module (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;
    reg next_state;
    reg z_reg;

    // State definitions
    localparam S_ZERO = 1'b0; // State before first '1' is seen
    localparam S_ONE  = 1'b1; // State after first '1' is seen

    // State transition logic
    always @(*) begin
        case (state)
            S_ZERO: begin
                if (x == 1'b1) begin
                    next_state = S_ONE;
                end else begin
                    next_state = S_ZERO;
                end
            end
            S_ONE: begin
                next_state = S_ONE;
            end
            default: next_state = S_ZERO;
        endcase
    end

    // State register update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= S_ZERO;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            z_reg <= 1'b0;
        end else begin
            case (state)
                S_ZERO: begin
                    z_reg <= x;
                end
                S_ONE: begin
                    z_reg <= ~x;
                end
                default: z_reg <= 1'b0;
            endcase
        end
    end

    assign z = z_reg;

endmodule